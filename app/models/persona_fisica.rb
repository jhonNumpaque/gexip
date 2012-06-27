class PersonaFisica < Ente
  #validaciones
  validates :apellido, :presence => true
  validates_uniqueness_of :documento
  
  def apellido_nombre
    "#{self.apellido}, #{self.nombre}".strip
  end
end
