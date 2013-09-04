class Macroproceso < Serieproceso
  # validaciones
  validates :clasificacion, :presence => true


#  before_destroy :check
#  def check
#    false unless procesos.empty?
#  end

# relacion
	belongs_to :cargo, :foreign_key => :cargo_id
	has_many :procesos, :foreign_key => :serieproceso_id, :dependent => :restrict
	has_one :version_aprobada, :foreign_key => :item_id, :conditions => { tipo_item: 'Macroproceso' }

  # Estratégico, Misional y de Apoyo.
  # @v_clasificacion_array = %w{ESTRATEGICO MISIONAL APOYO}
  CLASIFICACIONES = %w{ESTRATEGICO MISIONAL APOYO}
  TIPO_BUSQUEDA = %w{TODOS NOMBRE OBJETIVO CODIGO}
    
  # Concatena codigo y nombre, especial para usar en combobox
  def codigo_nombre
    "#{codigo} #{nombre}"
  end

	def aprobado
		self.version_aprobada.version.reify if self.version_aprobada.present?
	end
end
