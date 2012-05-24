class TareaExpediente < ActiveRecord::Base
  belongs_to :procedimiento
  belongs_to :expediente
  belongs_to :tarea
  
  INICIO = 'INICIO' # no sirve porque ya tiene sus estados
  
  # CONSTANTE
  ESTADO = %w{PROCESANDO FINALIZADO CANCELADO}
end
