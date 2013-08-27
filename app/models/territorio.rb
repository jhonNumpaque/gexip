class Territorio < ActiveRecord::Base
  	#validaciones
	validates :nombre, :presence => true, :uniqueness => { :scope => [:territorio_id, :type] }
end
