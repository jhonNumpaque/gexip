class Ente < ActiveRecord::Base
	validates :nombre, :presence => true
	#validates :apellido, :presence => true
	validates :documento, :presence => true
	validates :tipo_documento_id, :presence => true
	
  # asociaciones
	has_one :cargo
	belongs_to :tipo_documento
  belongs_to :ciudad, :foreign_key => :territorio_id
  
  def self.search(search)
      if search
        where(' nombre like ? or apellido like ? or documento like ?', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        scoped
      end
  end
end
