class Expediente < ActiveRecord::Base
  #validaciones
  validates :procedimiento_id, :presence => true
  validates :ente_id, :presence => true
  validates :usuario_id, :presence => true
  validates :descripcion, :presence => true
  validates :estado, :presence => true
  validates :usuario_ingreso_id, :presence => true
  validates :fecha_ingreso, :presence => true
  validates :numero, :presence => true
      
  #Relaciones
  belongs_to :procedimiento, :foreign_key => :procedimiento_id
  belongs_to :tarea, :foreign_key => :tarea_actual_id
  belongs_to :tarea, :foreign_key => :tarea_anterior_id
  belongs_to :ente, :foreign_key => :ente_id
  belongs_to :usuario, :foreign_key => :usuario_id
  belongs_to :usuario, :foreign_key => :usuario_ingreso_id
  belongs_to :usuario, :foreign_key => :usuario_finalizo_id
  
  # CONSTANTE
  ESTADO = %w{NUEVO RECIBIDO TRANSITO RECHAZADO FINALIZADO ANULADO PROCESANDO}
  
end
