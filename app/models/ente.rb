class Ente < ActiveRecord::Base
	validates :nombre, :presence => true
	validates :apellido, :presence => true
	validates :documento, :presence => true
	validates :tipo_documento_id, :presence => true
	
	has_one :cargo
	belongs_to :tipo_documento
end
