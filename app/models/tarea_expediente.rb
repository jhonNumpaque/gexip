class TareaExpediente < ActiveRecord::Base
  belongs_to :procedimiento
  belongs_to :expediente
  belongs_to :tarea
  
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
  
  def finalizado?
    !self.procesando?
  end
  
  def procesando?
    self.estado == self.class.estado_inicial
  end
  
  def finalizar!
    self.estado = self.class.estado_fin_correcto
  end
  
  def cancelar!
    self.estado = self.class.estado_fin_incorrecto
  end
  
  def tiempo_ejecucion
    tiempo_final = Time.now
    tiempo_final = self.fecha_fin if self.fecha_fin.present?    
    
    Time.diff(self.created_at, tiempo_final)
  end
end
