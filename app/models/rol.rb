class Rol < ActiveRecord::Base
	#validaciones
	validates :nombre, :presence => true
  validate :al_menos_un_permiso
  
  # relaciones
  has_many :roles_permisos, :dependent => :destroy
  has_many :permisos, :through => :roles_permisos
  
  accepts_nested_attributes_for :roles_permisos, :reject_if => lambda { |a| a[:permiso_id].blank? }, :allow_destroy => true
  
  def al_menos_un_permiso
    errors.add(:permisos, 'debe tener al menos un permiso') if permisos_vacio?
  end
  
  def permisos_vacio?
    self.permisos.empty? or self.permisos.all? {|permiso| permiso.marked_for_destruction? }
  end
end
