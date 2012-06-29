class PersonaJuridica < Ente
  validates :documento, :format => {:with => %r/^[0-9]{1,}-[0-9]$/}, :uniqueness => true
  
  # CONSTANTE
  TIPO_BUSQUEDA = %w{NOMBRE DOCUMENTO DIRECCION TELEFONO}
  
end
