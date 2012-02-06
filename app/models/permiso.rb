class Permiso < ActiveRecord::Base
  
  # relaciones
  has_many :roles_permisos
  has_many :roles, :through => :roles_permisos
end
