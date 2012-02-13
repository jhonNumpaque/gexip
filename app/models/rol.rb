class Rol < ActiveRecord::Base
	#validaciones
	validates :nombre, :presence => true
  
  # relaciones
  has_many :roles_permisos, :dependent => :destroy
  has_many :permisos, :through => :roles_permisos
  
  accepts_nested_attributes_for :roles_permisos, :reject_if => lambda { |a| a[:permiso_id].blank? }, :allow_destroy => true
end
