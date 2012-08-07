class PersonaFisica < Ente
  #validaciones
  validates :apellido, :presence => true
  validates_uniqueness_of :documento
  
  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS NOMBRE APELLIDO DOCUMENTO}
  
  def apellido_nombre
    "#{self.apellido}, #{self.nombre}".strip
  end
end
