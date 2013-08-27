class CargoEstructuraAdjunto < ActiveRecord::Base
	belongs_to :cargo_estructura
	belongs_to :adjunto

	def descripcion
		self.cargo_estructura.descripcion
	end
end