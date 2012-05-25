class UnidadTiempo < ActiveRecord::Base
  validates :nombre, :presence => true
  validates :simbolo, :presence => true
  validates :minutos, :presence => true
end
