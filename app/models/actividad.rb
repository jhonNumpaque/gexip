class Actividad < ActiveRecord::Base
	
	belongs_to :procedimiento	
	
	has_many :tareas, :dependent => :restrict
	
end
