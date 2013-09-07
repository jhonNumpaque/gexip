class VistaExpedienteProceso < ActiveRecord::Base
  belongs_to :usuario, :foreign_key => :tarea_expediente_usuario_fin
end