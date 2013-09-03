class Actividad < ActiveRecord::Base

	has_paper_trail
	
	belongs_to :procedimiento	
	
	has_many :tareas, :dependent => :restrict
	has_one :version_aprobada, :foreign_key => :item_id, :conditions => { tipo_item: 'Actividad' }

	validates :descripcion, :presence => true, :uniqueness => { :scope => :procedimiento_id }
	validates :orden, :presence => true, :uniqueness => { :scope => :procedimiento_id }, :numericality => true

	# Callbacks
	before_validation :set_order

	def nombre
		self.descripcion
	end

	def tree_state
  	
	end

	def aprobado
		self.version_aprobada.version.reify if self.version_aprobada.present?
	end

	def aprobar!
		version_aprobada = VersionAprobada.where(item_id: self.id, tipo_item: self.class).first
		if version_aprobada
			version_aprobada.update_attribute(:version_id, self.versions.last.id)
		else
			VersionAprobada.create(item_id: self.id, tipo_item: self.class.to_s, version_id: self.versions.last.id)
		end
		self.aprobar_tareas!
	end

	def aprobar_tareas!
		self.tareas.map(&:aprobar!)
	end

	def has_tareas?
		self.tareas.count > 0
	end

	def finalizado?
		self.tareas.where('tipo = ?', 'fin').count > 0
	end

	private
  def set_order
		if self.new_record?
	    last_sibbling = self.procedimiento.actividades.order('orden').last
	    if last_sibbling
	      self.orden = last_sibbling.orden.next
	    else
	      self.orden = 1
	    end
  	end
  end
	
end
