class CargoEstructura < ActiveRecord::Base
  attr_accessible :cargo_id, :estructura_id
  
  belongs_to :cargo
  belongs_to :estructura
  has_many :funcionarios
end
