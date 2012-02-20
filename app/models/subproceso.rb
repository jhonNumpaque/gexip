class Subproceso < Serieproceso
  # relacion
  belongs_to :proceso, :foreign_key => :serieproceso_id
  belongs_to :cargo, :foreign_key => :cargo_id
  has_many :procedimientos	

end
