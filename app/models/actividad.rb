class Actividad < ActiveRecord::Base
	
	belongs_to :procedimiento	
	
	has_many :tareas, :dependent => :restrict

	def nombre
		self.descripcion
	end

	def tree_state
  	
  end
	
end
