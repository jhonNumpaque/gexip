class CargoEnte < ActiveRecord::Base
  attr_accessible :cargo_id, :ente_id
  
  belongs_to :cargo
  belongs_to :ente
end
