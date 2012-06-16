class VistaTarea < ActiveRecord::Base	
	
	belongs_to :tarea
	belongs_to :procedimiento
	belongs_to :actividad
  
  scope :del_cargo, lambda { |cargo_id| where(:cargo_id => cargo_id) }
	
end
