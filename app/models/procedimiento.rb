class Procedimiento < ActiveRecord::Base
	has_paper_trail :ignore => [:bloqueado,:estado]

	validates :nombre, :presence => true	
	validates :objetivo, :presence => true	
	#validates :elabora_usuario, :presence => true
	validates :serieproceso_id, :presence => true		
	
	has_many :actividades, :dependent => :restrict
	has_many :tareas, :through => :actividades
	belongs_to :elaborador, :class_name => 'Usuario', :foreign_key => 'elabora_usuario'
	belongs_to :revisador, :class_name => 'Usuario', :foreign_key => 'revisado_usuario'
	belongs_to :aprobador, :class_name => 'Usuario', :foreign_key => 'aprobado_usuario'
	belongs_to :subproceso, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => "serieprocesos.type = 'Subproceso'"
	belongs_to :proceso, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => "serieprocesos.type = 'Proceso'"
	belongs_to :serieproceso, :foreign_key => 'serieproceso_id'
	has_one :version_aprobada, :foreign_key => :item_id, :conditions => { tipo_item: 'Procedimiento' }

	scope :a_aprobar, where(estado: 'aprobable')
	scope :aprobados, where(estado: 'aprobado')
	scope :borradores, where(estado: 'pendiente')

	before_update :marcar_como_borrador
	
	
	accepts_nested_attributes_for :actividades, :reject_if => lambda { |a| a[:descripcion].blank? }, :allow_destroy => true
	
	def aprobado?
		self.aprobado_fecha.present? && self.aprobado_usuario.present?
	end

	def total_tareas
		tareas.count
	end

	def aprobado
		self.version_aprobada.version.reify if self.version_aprobada.present?
	end

	def por_autorizar?
		self.estado == 'aprobable'
	end

	def aprobar!
		self.update_attribute(:estado, 'aprobado')
		version_ap = VersionAprobada.where(item_id: self.id, tipo_item: self.class.to_s).first
		if version_ap
			version_ap.update_attribute(:version_id, self.versions.last.id)
		else
			VersionAprobada.create(item_id: self.id, tipo_item: self.class.to_s, version_id: self.versions.last.id)
		end
		self.bloquear!
		self.aprobar_actividades!
	end

	def aprobar_actividades!
		self.actividades.map(&:aprobar!)
	end

	def desaprobar!
		self.update_attribute(:estado, 'aprobable')
	end

	def bloquear!
		self.update_attribute(:bloqueado, true)
	end

	def desbloquear!
		self.update_attribute(:bloqueado, false)
	end

	def tree_state
  	'closed' if self.actividades.count > 0
	end

	def finalizado?
		ultimo = self.actividades.order('orden').last
		ultimo ? ultimo.finalizado? : false
	end

	def solicitar_autorizacion
		self.update_attribute(:estado, 'aprobable')
	end

	def actividades_completas?
		actividades_id = self.actividades.map(&:id)
		tareas_activades_id = Tarea.where(actividad_id: actividades_id).all.map(&:actividad_id)
		tareas_activades_id.uniq!
		actividades_id.uniq!
		(actividades_id-tareas_activades_id).blank?
	end

	 #recibe el tiempo en minutos
  def self.calcular_fecha_entrega(tiempo)
    if tiempo > 0
      tiempo_actual = DateTime.now
      puts tiempo_actual.wday
      #verificar si la consulta se realiza en horas laborales
      if ![6,7].include? tiempo_actual.wday
        if (Estructura::Hora_Trabajo_Inicio..Estructura::Hora_Trabajo_Fin).to_a.index(tiempo_actual.hour).present?
          horas_de_trabajo = (Estructura::Hora_Trabajo_Inicio..Estructura::Hora_Trabajo_Fin).to_a.index(12)
          minutos_de_trabajo = horas_de_trabajo * 60 #pasar las horas de trabajo a minutos trabajados para normalizar
          if (tiempo - minutos_de_trabajo) > 0
            tiempo = tiempo - minutos_de_trabajo #se resta el tiempo que se trabajara ese dia
          end
          dias_faltantes = tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
        else
          if tiempo_actual.hour < 7 #verificar si se pregunta en horas de la madrugada
            dias_faltantes += tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
          elsif tiempo_actual.hour > 15 #verificar si se pregunta en horas de la tarde
            dias_faltantes = 1.00
            dias_faltantes += tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
          end
        end
      else
        #En caso que la consulta se haga un sabado o un domingo
        dias_faltantes = tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
        if tiempo_actual.wday == 6
          dias_faltantes += 2.0
        elsif tiempo_actual.wday == 7
          dias_faltantes += 1.0
        end
      end
      #sumar la cantidad de dias, agregando los sabados y domingo
      cant_dias = 0
      (1 .. dias_faltantes).each do |d|
        fecha = tiempo_actual + d.days
        if fecha.wday == 6 || fecha.wday == 7
          cant_dias + 1
        end
      end
      dias_faltantes = dias_faltantes + cant_dias # se suma la cantidad de sabados y domingos
      minutos_faltantes = dias_faltantes.to_s.split('.')[1] #obtener los minutos restantes
      minutos_faltantes = '0.' + minutos_faltantes.to_s
      minutos_faltantes = minutos_faltantes.to_f
      minutos_faltantes *= Estructura::Minutos_Dias
      if minutos_de_trabajo.present?
        if (minutos_faltantes + minutos_de_trabajo) < Estructura::Minutos_Dias
          minutos_faltantes += minutos_de_trabajo #se agrega la cantidad de horas que ya se trabajo en el dia
        end
      end
      fecha_estimada = tiempo_actual + dias_faltantes.days #calcular la cantidad de dias
      fecha_entrega = DateTime.new(fecha_estimada.year, fecha_estimada.month, fecha_estimada.day, Estructura::Hora_Trabajo_Inicio) #se crea la nueva fecha con el tiempo a las 7am
      fecha_entrega = fecha_entrega + minutos_faltantes.minute #se suman los minutos faltantes para la entrega

      return fecha_entrega
    else
      return false
    end
  end

	def marcar_como_borrador
		campos_cambios = ['nombre', 'objetivo', 'definiciones']
		if (campos_cambios - self.changes.keys).length < 3
			self.estado = 'pendiente'
		end
	end
end
