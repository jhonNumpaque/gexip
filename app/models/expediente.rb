# encoding: utf-8
class Expediente < ActiveRecord::Base
  #validaciones
  #validates :procedimiento_id, :presence => true
  validates :ente_id, :presence => true
  #validates :usuario_id, :presence => true
  validates :descripcion, :presence => true
  validates :estado, :presence => true
  #validates :usuario_ingreso_id, :presence => true
  #validates :fecha_ingreso, :presence => true
  validates :numero, :presence => true, :uniqueness => true
  #validates :numero_documento, :presence => true

  #Relaciones
  #belongs_to :procedimiento, :foreign_key => :procedimiento_id
  #belongs_to :tarea_actual, :foreign_key => :tarea_actual_id, :class_name => 'Tarea'
  belongs_to :tarea_anterior, :foreign_key => :tarea_anterior_id, :class_name => 'Tarea'
  belongs_to :tarea_expediente_actual, :foreign_key => :tarea_expediente_actual_id, :class_name => 'TareaExpediente'
  belongs_to :ente, :foreign_key => :ente_id
  belongs_to :usuario
  has_many :tareas_expedientes
  has_many :tareas, :through => :tareas_expedientes
  has_many :adjuntos, :through => :tareas, :source => :adjuntos
  has_many :adjuntos_tareas_expedientes, :through => :tareas_expedientes
  #para determinar una tarea
  has_one :tarea, :through => :tarea_expediente_actual
  #has_many :adjuntos, :through => :tarea, :source => :adjuntos
  #belongs_to :usuario_ingreso, :foreign_key => :usuario_ingreso_id, :class_name => 'Usuario'
  #belongs_to :usuario_finalizado, :foreign_key => :usuario_finalizo_id, :class_name => 'Usuario'

  #has_many :tareas_expedientes, :dependent => :destroy

  #accepts_nested_attributes_for :adjuntos_tareas_expedientes, :reject_if => lambda { |a| a[:data].blank? }, :allow_destroy => true

  # CONSTANTE, si se modifica orden o se agrega cambiar métodos relacionados
  ESTADO = %w{NUEVO RECIBIDO TRANSITO RECHAZADO FINALIZADO ANULADO PROCESANDO}

  attr_accessor :procedimiento_id, :usuario_id

  # callbacks
  before_validation :generar_numero, :establecer_estado, :asignar_clave
  before_save :validar_documentos
  after_create :iniciar_proceso

  def generar_numero
    return true unless self.new_record?

    anyo = Date.today.year
    ultimo_expediente = Expediente.last

    ultimo_anyo = ultimo_expediente.anyo_ingreso if ultimo_expediente.present?

    if ultimo_expediente.blank? || (ultimo_anyo.to_s != anyo.to_s)
      numero = "#{anyo}#{1}"
    else
      numero = "#{anyo}#{ultimo_expediente.siguiente_numero}"
    end

    self.numero = numero
  end

  def asignar_clave
    self.clave = rand(10000..99999) if self.new_record?
  end

  def anyo_ingreso
    self.numero.to_s[0..3]
  end

  def numero_corto
    self.numero.to_s[4...self.numero.to_s.length]
  end

  def siguiente_numero
    n = self.numero.to_s
    n[4..n.length].next
  end

  def tarea_actual
    self.tarea_expediente_actual.tarea
  end

  def procedimiento
    self.tareas_expedientes.first.tarea.actividad.procedimiento
  end

  def usuario
    self.tareas_expedientes.first.usuario_inicio
  end

  def tarea_siguiente
    tarea = self.tarea_expediente_actual.tarea
    actividad = tarea.actividad
    cond_query = '((orden > :orden and actividad_id = :actividad) '
    cond_vals = {:orden => tarea.orden, :actividad => actividad.id,
                 :proced => actividad.procedimiento_id, :act_orden => actividad.orden}

    if tarea.es_proceso_no?
      cond_query += ' and (id <> :tarea_not_id)) '
      cond_vals[:tarea_not_id] = self.tarea_anterior.tarea_sgt_id
    elsif tarea.es_proceso_si?
      cond_query += ' and (id <> :tarea_not_id)) '
      cond_vals[:tarea_not_id] = self.tarea_anterior.tarea_alt_id
    else
      cond_query += ') '
    end
    cond_query += 'or (procedimiento_id = :proced and actividad_orden > :act_orden)'


    VistaTarea.where(cond_query, cond_vals).first
  end

  def tarea_actual_terminada?
    self.tarea_expediente_actual.fecha_fin.present?
  end

  # métodos de clase
  def self.estado_procesando
    ESTADO.last
  end

  private
  def establecer_estado
    return true unless self.new_record?

    self.estado = ESTADO[0]
  end

  def iniciar_proceso
    Expediente.transaction do
      procedimiento = Procedimiento.find(self.procedimiento_id)
      actividad = procedimiento.actividades.order('orden').first
      tarea = actividad.tareas.order('orden').first()

      # tarea_expediente_status contiene un array con true|false en 
      # el primer elemento (si se guardó o no el registro) y en el 
      # segundo elemento el objeto tarea_expediente
      tarea_expediente = TareaExpediente.crear!(
          :procedimiento_id => procedimiento.id,
          :expediente_id => self.id,
          :tarea_id => tarea.id,
          :usuario_inicio_id => self.usuario_id
      )


      fin = tarea_expediente.finalizar!(
          self.usuario_id,
          'Inicio del procedimiento (automático)'
      )

      self.update_attributes(:tarea_expediente_actual_id => tarea_expediente.id) if fin
    end
  end

  private
  def validar_documentos
    if self.adjuntos.present?
      if self.adjuntos_tareas_expedientes.present?
        if self.adjuntos.length == self.adjuntos_tareas_expedientes.length
          true
        else
          false
        end
      else
        false
      end
    else
      true
    end
  end

end
