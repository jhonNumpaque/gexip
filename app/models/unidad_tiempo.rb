class UnidadTiempo < ActiveRecord::Base
  validates :nombre, :presence => true
  validates :simbolo, :presence => true
  validates :minutos, :presence => true, :numericality => true
  
  has_many :tareas, :dependent => :restrict
end
