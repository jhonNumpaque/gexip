class Cargo < ActiveRecord::Base
	validates :nombre, :presence => true
    #validates :nombre, :uniqueness => true
  
	#has_many :ente, :dependent => :restrict
	has_many :cargos_estructuras, :dependent => :restrict
	has_many :funcionarios, :through => :cargos_estructuras
end
