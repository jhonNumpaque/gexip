# encoding: utf-8
class Expediente < ActiveRecord::Base
  #validaciones
  validates :procedimiento_id, :presence => true
  validates :ente_id, :presence => true
  validates :usuario_id, :presence => true
  validates :descripcion, :presence => true
  validates :estado, :presence => true
  validates :usuario_ingreso_id, :presence => true
  validates :fecha_ingreso, :presence => true
  validates :numero, :presence => true, :uniqueness => true
  #validates :numero_documento, :presence => true
      
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
  
  attr_accessor :numero_documento
  
  # callbacks
  before_validation :generar_numero, :establecer_estado
  
  def generar_numero
    return true unless self.new_record?
    
    anyo = Date.today.year
    ultimo_expediente = Expediente.last
    
    ultimo_anyo = ultimo_expediente.anyo_ingreso if ultimo_expediente.present?
    
    if ultimo_expediente.blank? || (ultimo_anyo.to_s != anyo.to_s)
      numero = "#{anyo}#{1}"
    else
      numero = "#{anyo}#{ultimo_expediente.siguiente_numero}"
    end
    
    self.numero = numero
  end
  
  def anyo_ingreso
    self.numero.to_s[0..3]
  end
  
  def siguiente_numero
    n = self.numero.to_s
    n[4..n.length].next
  end
  
  def establecer_estado
    return true unless self.new_record?
    
    self.estado = ESTADO[0]
  end
  
end
