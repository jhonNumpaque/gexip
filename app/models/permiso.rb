class Permiso < ActiveRecord::Base
  
  # relaciones
  has_many :roles_permisos
  has_many :roles, :through => :roles_permisos
  
  belongs_to :accion_principal, :class_name => 'Permiso', :foreign_key => 'permiso_id'
  
  # validaciones
   validates_uniqueness_of :controlador, :scope => :accion
   
  def secundario?
    self.permiso_id.present?
  end
end
