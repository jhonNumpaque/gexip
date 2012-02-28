class UnidadTiempo < ActiveRecord::Base
  validates :nombre, :presence => true
  validates :simbolo, :presence => true
end
