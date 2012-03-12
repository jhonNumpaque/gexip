class Tarea < ActiveRecord::Base
  #validaciones
#  validates :orden, :presence => true
  validates :nombre, :presence => true
  validates :tipo, :presence => true
  validates :cargo_id, :presence => true
  
  #Relaciones
  belongs_to :cargo, :foreign_key => :cargo_id
  belongs_to :actividad, :foreign_key => :actividad_id

  # CONSTANTE
  TIPO_TAREA = %w{INICIO PROCESO TRANSLADO ALMACENAMIENTO LOGICA FIN FIN_ALTERNANTIVO}
  
  attr_accessor :tarea_anterior_id
  
  # callbacks
  after_save :actualizar_tarea_anterior
  
#  def tarea_anterior_id=(value)
#    @anterior_id = value
#  end
  
  def actualizar_tarea_anterior
    if self.tarea_anterior_id
      anterior = self.class.find(self.tarea_anterior_id)
      anterior.update_attribute('tarea_sgt_id', self.tarea_anterior_id)
    end
  end
  
  def self.tareas_anteriores(actividad_id, me_id)
    ant = []
    ant << Tarea.where('id <> ? AND tipo = ? AND (tarea_sgt_id is ? OR tarea_alt_id is ?) AND actividad_id = ?', me_id, 'LOGICA', nil, nil, actividad_id).all
    ant << Tarea.where('id <> ? AND tarea_sgt_id is ? AND actividad_id = ?', me_id, nil, actividad_id).order('id desc').last
    ant
  end
end