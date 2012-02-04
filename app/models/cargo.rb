class Cargo < ActiveRecord::Base
	validates :nombre, :presence => true
	
	belongs_to :ente
end
