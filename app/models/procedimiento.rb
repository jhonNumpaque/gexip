class Procedimiento < ActiveRecord::Base
	validates :nombre, :presence => true	
	validates :objetivo, :presence => true	
	validates :elabora_usuario, :presence => true		
	validates :serieproceso_id, :presence => true		
	
	has_many :actividades, :dependent => :restrict
	belongs_to :elaborador, :class_name => 'Usuario', :foreign_key => 'elabora_usuario'
	belongs_to :revisador, :class_name => 'Usuario', :foreign_key => 'revisado_usuario'
	belongs_to :aprobador, :class_name => 'Usuario', :foreign_key => 'aprobado_usuario'
	belongs_to :subproceso, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => "serieprocesos.type = 'Subproceso'"
	belongs_to :proceso, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => "serieprocesos.type = 'Proceso'"
	belongs_to :serieproceso, :foreign_key => 'serieproceso_id'

	scope :a_aprobar, where(estado: 'aprobable')
	scope :aprobados, where(estado: 'aprobado')
	scope :borradores, where(estado: 'pendiente')
	
	
	accepts_nested_attributes_for :actividades, :reject_if => lambda { |a| a[:descripcion].blank? }, :allow_destroy => true
	
	def aprobado?
		self.aprobado_fecha.present? && self.aprobado_usuario.present?
	end

	def total_tareas
		Tarea.where('actividad_id in (?)', self.actividades.select('id').map(&:id)).count
	end

	def por_autorizar?
		self.estado == 'autorizar'
	end

	def aprobar!
		self.update_attribute(:estado, 'aprobado')
	end

	def bloquear!
		self.update_attribute(:bloqueado, true)
	end

	def desbloquear!
		self.update_attribute(:bloqueado, false)
	end

	def tree_state
  	'closed' if self.actividades.count > 0
	end

	def finalizado?
		ultimo = self.actividades.order('orden').last
		ultimo ? ultimo.finalizado? : false
	end

	def solicitar_autorizacion
		self.update_attribute(:estado, 'autorizar')
	end

	def actividades_completas?
		actividades_id = self.actividades.map(&:id)
		tareas_activades_id = Tarea.where(actividad_id: actividades_id).all.map(&:actividad_id)
		tareas_activades_id.uniq!
		actividades_id.uniq!
		(actividades_id-tareas_activades_id).blank?
	end
end
