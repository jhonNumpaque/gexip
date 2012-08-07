class OrganismoInterno < Ente
  #validaciones
  validates_uniqueness_of :documento
  
  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS ORGANISMO NRO.REGISTRO}
end
