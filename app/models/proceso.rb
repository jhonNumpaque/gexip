class Proceso < Serieproceso
      # relacion
    belongs_to :macroproceso, :foreign_key => :serieproceso_id
    belongs_to :cargo, :foreign_key => :cargo_id
end
