class PersonaJuridica < Ente
	#formato para el ruc
	validates :documento, :format => {:with => %r/^[0-9]{1,}-[0-9]{1,}$/}, :uniqueness => true
	
  # CONSTANTE
  TIPO_BUSQUEDA = %w{NOMBRE DOCUMENTO DIRECCION TELEFONO}
  
end
