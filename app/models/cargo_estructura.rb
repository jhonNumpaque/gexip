class CargoEstructura < ActiveRecord::Base
  attr_accessible :cargo_id, :estructura_id

  validates :cargo_id, :presence => true, :uniqueness => { :scope => :estructura_id }
  validates :estructura_id, :presence => true, :uniqueness => { :scope => :cargo_id }
  
  belongs_to :cargo
  belongs_to :estructura
  has_many :funcionarios
  has_many :serieprocesos
  has_many :procedimientos, :through => :serieprocesos

  def descripcion
  	"#{cargo.nombre} de #{estructura.nombre}"
  end
end
