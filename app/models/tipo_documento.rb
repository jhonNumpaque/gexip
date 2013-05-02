class TipoDocumento < ActiveRecord::Base
	has_many :entes
	has_many :personas_fisicas	
	
	validates :nombre, :presence => true
	validates :formato, :presence => true
	
end
