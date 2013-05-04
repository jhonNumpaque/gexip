class OrganismoInterno < Ente
  #validaciones
  validates_uniqueness_of :documento
  

  has_many :cargos_entes, :dependent => :restrict, :foreign_key => :ente_id
  has_many :cargos, :through => :cargos_entes

  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS ORGANISMO NRO.REGISTRO}
end
