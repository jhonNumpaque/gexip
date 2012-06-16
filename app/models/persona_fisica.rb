class PersonaFisica < Ente
  #validaciones
  validates :apellido, :presence => true
    
  def apellido_nombre
    "#{self.apellido}, #{self.nombre}".strip
  end
end
