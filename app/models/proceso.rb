class Proceso < Serieproceso
	has_paper_trail

  # relacion
  belongs_to :macroproceso, :foreign_key => :serieproceso_id
  belongs_to :cargo_estructura
  has_many :subprocesos, :foreign_key => :serieproceso_id, :dependent => :restrict, :conditions => { :type => 'Subproceso' }
	has_one :version_aprobada, :foreign_key => :item_id, :conditions => { tipo_item: 'Proceso' }
  #has_many :procedimientos, :foreign_key => :serieproceso_id, :dependent => :restrict, :conditions => { :type => 'Procedimiento' }
  
  #constantes
  TIPO_BUSQUEDA = %w{TODOS NOMBRE OBJETIVO CODIGO}
  
  # Concatena codigo y nombre, especial para usar en combobox
  def codigo_nombre
    "#{codigo} #{nombre}"
  end

  def self.calcular_tiempo_total

  end
end
