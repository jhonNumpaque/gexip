class Estructura < ActiveRecord::Base

  validates :nombre, :presence => true
  
  has_many :cargos_estructuras, :dependent => :restrict, :foreign_key => :estructura_id
  has_many :cargos, :through => :cargos_estructuras
  has_many :funcionarios, :through => :cargos_estructuras

  belongs_to :estructura

  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS NOMBRE}
  Hora_Trabajo_Inicio = 7
  Hora_Trabajo_Fin = 15
  Minutos_Dias = 480 #minutos equivalentes a 8 horas
  Minutos_Semana = 2400 #minutos equivalentes a una semana
end
