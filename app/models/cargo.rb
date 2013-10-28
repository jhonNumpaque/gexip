class Cargo < ActiveRecord::Base
	validates :nombre, :presence => true, :uniqueness => true
    #validates :nombre, :uniqueness => true
  
	#has_many :ente, :dependent => :restrict
	has_many :cargos_estructuras, :dependent => :restrict
	has_many :funcionarios, :through => :cargos_estructuras

	scope :de_la_estructura, lambda { |estructura_id| where(:estructura_id => estructura_id)}
end
