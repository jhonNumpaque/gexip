class Tarea < ActiveRecord::Base
  #validaciones
# validates :orden, :presence => true
  validates :nombre, :presence => true
  validates :tipo, :presence => true
  validates :cargo_id, :presence => true
  
  #Relaciones
  belongs_to :cargo, :foreign_key => :cargo_id
  belongs_to :actividad, :foreign_key => :actividad_id

  # CONSTANTE
  TIPO_TAREA = %w{INICIO PROCESO TRANSLADO ALMACENAMIENTO LOGICA FIN FIN_ALTERNANTIVO}

end