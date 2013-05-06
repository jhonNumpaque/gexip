class Serieproceso < ActiveRecord::Base
  #validaciones
  validates :nombre, :presence => true
  validates :objetivo, :presence => true
  validates :codigo, :presence => true, :uniqueness => true

  has_many :serieprocesos
  has_many :procedimientos

  belongs_to :cargo_ente
  has_one :cargo, :through => :cargo_ente

  def tree_state
  	'closed' if self.serieprocesos_count > 0 || self.procedimientos_count > 0
  end
end
