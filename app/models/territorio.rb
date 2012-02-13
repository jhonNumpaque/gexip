class Territorio < ActiveRecord::Base
  	#validaciones
	validates :nombre, :presence => true
end
