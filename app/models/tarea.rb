class Tarea < ActiveRecord::Base
  #validaciones
#  validates :orden, :presence => true
  validates :nombre, :presence => true
  validates :tipo, :presence => true
  validates :cargo_estructura_id, :presence => true
  validates :tiempo_ejecucion, :presence => true
  
  #Relaciones
  belongs_to :cargo_estructura
  belongs_to :actividad, :foreign_key => :actividad_id
  belongs_to :unidad_tiempo, :foreign_key => :unidad_tiempo_id
  belongs_to :tarea_siguiente, :foreign_key => :tarea_sgt_id, :class_name => 'Tarea'
  belongs_to :tarea_alternativa, :foreign_key => :tarea_alt_id, :class_name => 'Tarea'

  has_many :tareas_dependientes, :foreign_key => :logica_relacionada_id, :class_name => 'Tarea'
  has_many :adjuntos

  # CONSTANTE
  TIPO_TAREA = %w{INICIO PROCESO PROCESO_SI PROCESO_NO TRANSLADO ALMACENAMIENTO LOGICA FIN FIN_ALTERNANTIVO}
  TIPO_TAREA_LOGICA = 'LOGICA'
  RutasLogicas = ['SI','NO']

  #Gems
  acts_as_nested_set
  
  attr_accessor :tarea_anterior_id, :respuesta_logica
  
  # callbacks
  before_create :verificar_orden
  after_save :actualizar_tarea_siguiente
  before_validation :complete_data

  accepts_nested_attributes_for :adjuntos, :reject_if => lambda { |a| a[:descripcion].blank? }, :allow_destroy => true
  
#  def tarea_anterior_id=(value)
#    @anterior_id = value
#  end

  def actualizar_tarea_siguiente
    if self.tarea_ant_id
      anterior = self.class.find(self.tarea_ant_id)
      if (anterior.es_logica? && self.es_proceso_si?) || !anterior.es_logica?
        anterior.tarea_sgt_id = self.id
        anterior.estado = anterior.estado_logica if anterior.es_logica?
        anterior.save
      elsif (anterior.es_logica? && self.es_proceso_no?)
        anterior.tarea_alt_id = self.id
        anterior.estado = anterior.estado_logica if anterior.es_logica?
        anterior.save
      end
    end
  end

  def arbol(tipo=:tarea_siguiente)
    tareas = []
    tarea = self
    while tarea.send(tipo)
      tareas << tarea.send(tipo)
      tarea = tarea.send(tipo)
    end
    tareas
  end

  def orden_nombre
    "#{self.orden} #{self.nombre}"
  end
  
  def es_logica?
    self.tipo.upcase == TIPO_TAREA_LOGICA
  end

  def otras_tareas
    otras = self.actividad.tareas.where('tipo not in (?)', ['logica', 'inicio']).order('orden').all
    otras.compact!
    otras.delete(self)
    otras
  end

  def anterior
    Tarea.where(actividad_id: self.actividad_id).order('orden').last    
  end

  def tree_state
    
  end
  
  def es_proceso_si?
    self.tipo_logica? && self.tipo_logica.downcase == 'si'
  end
  
  def es_proceso_no?
    self.tipo_logica? && self.tipo_logica.downcase == 'no'
  end

  def logica_nueva?
    self.tipo_logica? && self.estado == 'nuevo'
  end

  def es_respuesta_logica?
    self.tipo.upcase == 'PROCESO_NO' || self.tipo.upcase == 'PROCESO_SI'
  end

  def logicos_pendientes
    @logicos ||= self.actividad.tareas.where(tipo: 'logica', :estado => ['abierto', 'nuevo']).order('orden')
  end

  def logica_abierta
    Tarea.where("(tarea_sgt_id is null or tarea_alt_id is null) and tipo = 'logica'").last
  end

  def logica_si_retrocedio
    
  end
  
  def logica_no_retrocedio
  end

	def tipo_logica_sup
		return self.ruta_pendiente if self.es_logica?
		self.tipo_logica.upcase
	end

	def ruta_pendiente
		self.tarea_sgt_id? ? 'NO' : 'SI'
	end

	def rutas_pendientes(tarea_logica)
		pendientes = []
		pendientes << 'SI' unless tarea_logica.tarea_sgt_id?
		pendientes << 'NO' unless tarea_logica.tarea_alt_id?
		pendientes
	end

  def self.tareas_anteriores(actividad_id, me_id)
    ant = []
    filtx = Tarea.where('tipo = ? AND (tarea_sgt_id is ? OR tarea_alt_id is ?) AND actividad_id = ?', 'LOGICA', nil, nil, actividad_id)
    filtx = filtx.where('id <> ?', me_id) if me_id.present?
    ant << filtx.all
    filt = Tarea.where('tarea_sgt_id is ? AND actividad_id = ?', nil, actividad_id).order('id desc')
    filt = filt.where('id <> ?', me_id) if me_id.present?
    ant << filt.last
    ant.delete(nil)
    ant.flatten!
  end

	def respuestas_logicas_pendientes(tipos_logica=['si','no'])
		@pendientes ||= self.class.where('tipo <> ? and tarea_sgt_id is ? and tipo_logica in (?) and actividad_id = ?',
		                 'logica', nil, tipos_logica, self.actividad_id).order('id desc').all
		@pendientes ||= []
		@pendientes
	end

	def dos_respuestas_pendientes?
		respuestas_pendientes? && respuestas_logicas_pendientes.length == 2
	end

	def dos_rutas_pendientes?
		self.es_logica? && !self.tarea_sgt_id? && !self.tarea_alt_id?
	end

	def rutas_pendientes?
		self.es_logica? && (!self.tarea_sgt_id? || !self.tarea_alt_id?)
	end

	def logica_volvio?
		self.es_logica? && (logica_sgte_volvio? || logica_alt_volvio?)
	end

	def logica_alt_volvio?
		self.tarea_alt_id < self.id
	end

	def logica_sgte_volvio?
		self.tarea_sgt_id < self.id
	end

	def tipo_logica_pendiente
		self.logica_rutas_pendientes.first.downcase if self.logica_rutas_pendientes.first
	end

	def logica_rutas_pendientes
		pendientes = []
		if self.es_logica?
			pendientes << 'si' unless self.tarea_sgt_id?
			pendientes << 'no' unless self.tarea_alt_id?
		end
	  pendientes
	end

	def respuestas_pendientes?
		respuestas_logicas_pendientes.present?
	end

	def ruta_disponible?(tipo='si')
		return false if (tipo == 'si' && self.id > self.tarea_sgt_id) || (tipo == 'no' && self.id > self.tarea_alt_id)
		ultima_tarea = ultima_en_rama(tipo)
		ultima_tarea ? ultima_tarea.abierto? : false
	end

	def ultima_en_rama(tipo)
		self.tareas_dependientes.where(tipo_logica: tipo).order('orden').last
	end

	def rutas_completadas
		completadas = []
		completadas << 'si' if self.tarea_sgt_id?
		completadas << 'no' if self.tarea_alt_id?
		completadas
	end

	def abierto?
		!['logica','fin'].include? self.tipo
	end

	def logica_pendiente
		logicos_pendientes.first
	end

	def una_sola_logica?
		logicas_pendientes? && logicos_pendientes.length == 1
	end

	def respuesta_pendiente
		respuestas_logicas_pendientes.first
	end

	def logicas_abiertas
		pendientes = []
		@logicas_actividad ||= self.class.where('tipo = ? and actividad_id = ?', 'logica', self.actividad_id).all
		@logicas_actividad.each do |logica|
			if logica.rutas_pendientes?
				pendientes << logica
			elsif logica.hijos_pendientes.present?
				pendientes << logica
			end
		end

	end

	def hijos_logicos(tipo='si')
		self.tareas_dependientes.where(tipo: 'logico', tipo_logico: tipo).all
	end

	def hijo_finalizado(tipo='si')
		self.tareas_dependientes.where(tipo: 'fin', tipo_logico: tipo).all
	end

	def ambas_logicas?
		hijos_logicos.present? && hijos_logicos('no').present?
	end

	def ambas_finalizadas?
		hijo_finalizado.present? && hijo_finalizado('no').present?
	end

	def hijos_cerrados?
		(hijo_finalizado.present? || hijos_logicos.present?) && (hijo_finalizado('no').present? || hijos_logicos('no').present?)
	end

	def esta_abierto?

	end

	def hijos_pendientes
		self.tareas_dependientes.where('tipo not in (?) and tarea_sgt_id is null', ['logica','fin']).all
	end

	def logicas_pendientes?
		logicos_pendientes.present?
	end

  protected
  def estado_logica
    if self.tarea_sgt_id.blank? && self.tarea_alt_id.blank?
      return 'nuevo'
    elsif self.tarea_sgt_id.present? && self.tarea_alt_id.present?
      return 'cerrado'
    else
      return 'abierto'
    end
  end

  private
  def verificar_orden
    self.orden = self.actividad.tareas.count + 1
  end

  def complete_data
    last_task = self.actividad.tareas.last
    #self.tarea_alt_id ||= last_task.id if last_task && !self.es_logica?
    case self.tipo.downcase
    when 'logica'      
      self.unidad_tiempo_id = UnidadTiempo::MinutoId
      self.tiempo_ejecucion = 10
      self.cargo_estructura_id = last_task.cargo_estructura_id
      self.estado = estado_logica
    when 'proceso'

    end
    if self.tipo_logica
      self.tarea_ant_id = self.logica_abierta.id
      self.tipo_logica.downcase!
    end
    puts "------------------+"
    puts self.tarea_ant_id
    puts "------------------++"
  end
end
