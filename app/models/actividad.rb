class Actividad < ActiveRecord::Base
	
	belongs_to :procedimiento	
	
	has_many :tareas, :dependent => :restrict

	validates :descripcion, :presence => true, :uniqueness => { :scope => :procedimiento_id }
	validates :orden, :presence => true, :uniqueness => { :scope => :procedimiento_id }, :numericality => true

	# Callbacks
	before_validation :set_order

	def nombre
		self.descripcion
	end

	def tree_state
  	
	end

	def has_tareas?
		self.tareas.count > 0
	end

	def finalizado?
		self.tareas.where('tipo = ?', 'fin').count > 0
	end

	private
  def set_order
  	last_sibbling = self.procedimiento.actividades.order('orden').last
  	if last_sibbling
  		self.orden = last_sibbling.orden.next
  	else
  		self.orden = 1
  	end
  end
	
end
