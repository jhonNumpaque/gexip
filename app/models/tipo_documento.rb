class TipoDocumento < ActiveRecord::Base
	has_many :entes	
	
	validates :nombre, :presence => true
	validates :formato, :presence => true
	
end
