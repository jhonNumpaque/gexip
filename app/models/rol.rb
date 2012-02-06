class Rol < ActiveRecord::Base
	#validaciones
	validates :nombre, :presence => true
  
  # relaciones
  has_many :roles_permisos
  has_many :permisos, :through => :roles_permisos
end
