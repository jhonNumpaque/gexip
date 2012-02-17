class Macroproceso < Serieproceso
  # validaciones
    validates :clasificacion, :presence => true
    # relacion
    belongs_to :cargo, :foreign_key => :cargo_id
end
