class Procedimiento < ActiveRecord::Base
	validates :nombre, :presence => true	
	validates :objetivo, :presence => true	
	validates :elabora_usuario, :presence => true		
	
	has_many :actividades
	belongs_to :elaborador, :class_name => 'Usuario', :foreign_key => 'elabora_usuario'
	belongs_to :revisador, :class_name => 'Usuario', :foreign_key => 'revisado_usuario'
	belongs_to :aprobador, :class_name => 'Usuario', :foreign_key => 'aprobado_usuario'
	belongs_to :subproceso, :foreign_key => 'serieproceso_id'
	
	
	accepts_nested_attributes_for :actividades, :reject_if => lambda { |a| a[:descripcion].blank? }, :allow_destroy => true
	
	
end
