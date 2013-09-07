class VistaExpedienteProceso < ActiveRecord::Base
  belongs_to :usuario_fin, :foreign_key => :tarea_expediente_usuario_fin, :class_name => 'Usuario'
  belongs_to :usuario_inicio, :foreign_key => :tarea_expediente_usuario_inicio, :class_name => 'Usuario'
end