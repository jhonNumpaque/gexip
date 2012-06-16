# encoding: utf-8
class Expediente < ActiveRecord::Base
  #validaciones
  validates :procedimiento_id, :presence => true
  validates :ente_id, :presence => true
  validates :usuario_id, :presence => true
  validates :descripcion, :presence => true
  validates :estado, :presence => true
  validates :usuario_ingreso_id, :presence => true
  validates :fecha_ingreso, :presence => true
  validates :numero, :presence => true, :uniqueness => true
  #validates :numero_documento, :presence => true
      
  #Relaciones
  belongs_to :procedimiento, :foreign_key => :procedimiento_id
  belongs_to :tarea_actual, :foreign_key => :tarea_actual_id, :class_name => 'Tarea'
  belongs_to :tarea_anterior, :foreign_key => :tarea_anterior_id, :class_name => 'Tarea'
  belongs_to :tarea_expediente_actual, :foreign_key => :tarea_expediente_actual_id, :class_name => 'TareaExpediente'
  belongs_to :ente, :foreign_key => :ente_id
  belongs_to :usuario
  belongs_to :usuario_ingreso, :foreign_key => :usuario_ingreso_id, :class_name => 'Usuario'
  belongs_to :usuario_finalizado, :foreign_key => :usuario_finalizo_id, :class_name => 'Usuario'
  
  #has_many :tareas_expedientes, :dependent => :destroy
  
  # CONSTANTE
  ESTADO = %w{NUEVO RECIBIDO TRANSITO RECHAZADO FINALIZADO ANULADO PROCESANDO}
  
  attr_accessor :numero_documento
  
  # callbacks
  before_validation :generar_numero, :establecer_estado
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
  
  def tarea_siguiente
    tarea = self.tarea_actual
    actividad = tarea.actividad    
    cond_query = '(orden > ? and actividad_id = ?) or (procedimiento_id = ? and actividad_orden > ?)'    
    VistaTarea.where(cond_query, tarea.orden, actividad.id, actividad.procedimiento_id, actividad.orden).first    
  end
  
  def tarea_actual_terminada?
    self.tarea_expediente_actual.fecha_fin.present?
  end

  private
  def establecer_estado
    return true unless self.new_record?
    
    self.estado = ESTADO[0]
  end
  
  def iniciar_proceso
    procedimiento = self.procedimiento
    actividad = procedimiento.actividades.order('orden').first
    tarea = actividad.tareas.order('orden').first()
    
    tarea_expediente = TareaExpediente.new
    tarea_expediente.procedimiento = procedimiento
    tarea_expediente.expediente = self
    tarea_expediente.tarea = tarea
    tarea_expediente.usuario_inicio_id = self.usuario_id
    tarea_expediente.fecha_inicio = Time.now
    tarea_expediente.estado = TareaExpediente::INICIO
    tarea_expediente.observacion_envio = 'Inicio del procedimiento (automático)'
    tarea_expediente.fecha_fin = Time.now
    tarea_expediente.save
    
    self.update_attributes(:tarea_actual_id => tarea.id,
      :tarea_expediente_actual_id => tarea_expediente.id)
    
  end

end
