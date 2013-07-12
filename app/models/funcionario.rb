class Funcionario < ActiveRecord::Base
	validates :nombres, :presence => true
	validates :apellidos, :presence => true
	validates :documento, :presence => true
	validates :tipo_documento_id, :presence => true
  validates :territorio_id, :presence => true
	
  # asociaciones
  #has_one :cargo
  #belongs_to :cargo, :foreign_key => :cargo_id

  #has_many :usuario
  belongs_to :tipo_documento
  belongs_to :ciudad, :foreign_key => :territorio_id
  belongs_to :cargo_estructura, :foreign_key => :cargo_estructura_id
  has_one :cargo, :through => :cargo_estructura  
  has_one :estructura, :through => :cargo_estructura  
    
  
  # CONSTANTE
  TIPO_BUSQUEDA = %w{TODOS NOMBRE APELLIDO DOCUMENTO DIRECCION TELEFONO}
  
  def self.search(form, search = nil, documento = nil, nombre = nil, apellido = nil, direccion = nil, telefono = nil)
    filtro = self
    if form == 'avanzado'      
      
      filtro = filtro.where('documento = ?', documento.to_s) if documento.present?
      filtro = filtro.where(' nombres like ?', "%#{nombre}%") if nombre.present?
      filtro = filtro.where(' apellidos like ?', "%#{apellido}%") if apellido.present?
      filtro = filtro.where(' direccion like ?', "%#{direccion}%") if direccion.present?
      filtro = filtro.where(' telefono like ?', "%#{telefono}%") if telefono.present?
    
    elsif search      
      filtro = filtro.where(' nombre like ? or apellido like ? or documento like ?', "%#{search}%", "%#{search}%", "%#{search}%")                
    end
    filtro
  end
  
  def nombre_completo
    "#{self.nombres} #{self.apellidos}".strip
  end
  
  def apellido_nombre
    "#{self.apellidos}, #{self.nombres}".strip
  end
end