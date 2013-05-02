class Cargo < ActiveRecord::Base
	validates :nombre, :presence => true
    validates :nombre, :uniqueness => true
  
	#has_many :ente, :dependent => :restrict
	has_many :cargos_entes, :dependent => :restrict
	has_many :entes, :through => :cargos_entes
end
