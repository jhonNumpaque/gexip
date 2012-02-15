class Serieproceso < ActiveRecord::Base
  #validaciones
  validates :nombre, :presence => true
  validates :objetivo, :presence => true
  validates :codigo, :presence => true, :uniqueness => true
end
