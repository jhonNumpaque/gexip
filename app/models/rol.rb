class Rol < ActiveRecord::Base
	#validaciones
	validates :nombre, :presence => true
end
