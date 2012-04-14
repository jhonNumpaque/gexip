class Ente < ActiveRecord::Base
	validates :nombre, :presence => true
	#validates :apellido, :presence => true
	validates :documento, :presence => true
	validates :tipo_documento_id, :presence => true
	
  # asociaciones
	has_one :cargo
	belongs_to :tipo_documento
  belongs_to :ciudad, :foreign_key => :territorio_id
  
  def self.search(form, search = nil, documento = nil, nombre = nil, apellido = nil, direccion = nil, telefono = nil)
#    filtro = scoped
    if form == 'avanzado'      
      
#      filtro.where('documento = ?', documento) if documento
      where(' nombre like ?', "%#{nombre}%") if nombre
      where(' apellido like ?', "%#{apellido}%") if apellido
#      filtro.where(' direccion like ?', "%#{direccion}%") if direccion
#      filtro.where(' telefono like ?', "%#{telefono}%") if telefono
    
    else
      if search
        filtro.where(' nombre like ? or apellido like ? or documento like ?', "%#{search}%", "%#{search}%", "%#{search}%")          
      end
    end
#    filtro
  end
end
