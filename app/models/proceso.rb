class Proceso < Serieproceso
  # relacion
  belongs_to :macroproceso, :foreign_key => :serieproceso_id
  belongs_to :cargo, :foreign_key => :cargo_id
  has_many :subproceso
  
  # Concatena codigo y nombre, especial para usar en combobox
  def codigo_nombre
    "#{codigo} #{nombre}"
  end
end
