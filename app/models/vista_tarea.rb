class VistaTarea < ActiveRecord::Base	
	
	belongs_to :tarea
	belongs_to :procedimiento
	belongs_to :actividad
  
  scope :del_cargo, lambda { |cargo_id| where(:cargo_id => cargo_id) }
	
  def es_logica?
    self.tipo == Tarea::TIPO_TAREA_LOGICA
  end
  
end
