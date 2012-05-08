class TareaExpediente < ActiveRecord::Base
  belongs_to :procedimiento
  belongs_to :expediente
  belongs_to :tarea
  
  INICIO = 'INICIO'
end
