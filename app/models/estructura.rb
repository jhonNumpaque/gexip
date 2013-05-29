class Estructura < ActiveRecord::Base

  validates :nombre, :presence => true
  
  has_many :cargos_estructuras, :dependent => :restrict, :foreign_key => :estructura_id
  has_many :cargos, :through => :cargos_estructuras
  has_many :funcionarios, :through => :cargos_estructuras

  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS NOMBRE}
end
