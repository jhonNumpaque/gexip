class TareaExpediente < ActiveRecord::Base
  belongs_to :procedimiento
  belongs_to :expediente
  belongs_to :tarea
  
  validates :procedimiento_id, :presence => true
  validates :expediente_id, :presence => true
  validates :tarea_id, :presence => true
  validates :usuario_inicio_id, :presence => true
  validates :fecha_inicio, :presence => true
  validates :estado, :presence => true
  
  INICIO = 'INICIO' # no sirve porque ya tiene sus estados
  
  # CONSTANTE
  ESTADO = %w{PROCESANDO FINALIZADO CANCELADO}
  
  def self.estado_inicial
    ESTADO[0]
  end
  
  def self.estado_fin_correcto
    ESTADO[1]
  end
  
  def self.estado_fin_incorrecto
    ESTADO[2]
  end
    
  def self.crear!(fields = {})    
    raise ArgumentError, 'campos incompletos' if fields.empty?
    
    tarea_expediente = new(
      :procedimiento_id => fields[:procedimiento_id],
      :expediente_id => fields[:expediente_id],
      :tarea_id => fields[:tarea_id],
      :usuario_inicio_id => fields[:usuario_inicio_id],
      :fecha_inicio => Time.now,
      :estado => estado_inicial
    )
    tarea_expediente.save!
    tarea_expediente
  end
  
  def finalizado?
    !self.procesando?
  end
  
  def procesando?
    self.estado == self.class.estado_inicial
  end
  
  def finalizar!(usuario_fin_id, observacion = nil )    
    self.update_attributes(
      :estado => self.class.estado_fin_correcto,
      :usuario_fin_id => usuario_fin_id,
      :observacion_envio => observacion,
      :fecha_fin => Time.now
    )    
  end
  
  def cancelar!(usuario_fin_id)
    self.update_attributes(
      :fecha_fin => Time.now,
      :estado => self.class.estado_fin_incorrecto,
      :usuario_find_id => usuario_fin_id)    
  end
  
  def tiempo_ejecucion
    tiempo_final = Time.now
    tiempo_final = self.fecha_fin if self.fecha_fin.present?    
    
    Time.diff(self.created_at, tiempo_final)
  end
end
