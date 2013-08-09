class Procedimiento < ActiveRecord::Base
  validates :nombre, :presence => true
  validates :objetivo, :presence => true
  validates :elabora_usuario, :presence => true
  validates :serieproceso_id, :presence => true

  has_many :actividades, :dependent => :restrict
  belongs_to :elaborador, :class_name => 'Usuario', :foreign_key => 'elabora_usuario'
  belongs_to :revisador, :class_name => 'Usuario', :foreign_key => 'revisado_usuario'
  belongs_to :aprobador, :class_name => 'Usuario', :foreign_key => 'aprobado_usuario'
  belongs_to :subproceso, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => 'serieprocesos.type = "Subproceso"'
  belongs_to :procesos, :foreign_key => 'serieproceso_id', :counter_cache => true, :conditions => 'serieprocesos.type = "Proceso"'


  accepts_nested_attributes_for :actividades, :reject_if => lambda { |a| a[:descripcion].blank? }, :allow_destroy => true

  def aprobado?
    self.aprobado_fecha.present? && self.aprobado_usuario.present?
  end

  def tree_state
    'closed' if self.actividades.count > 0
  end

  #recibe el tiempo en minutos
  def self.calcular_fecha_entrega(tiempo)
    if tiempo > 0
      tiempo_actual = DateTime.now
      #verificar si la consulta se realiza en horas laborales
      if tiempo_actual.wday != 6 || tiempo_actual.wday != 6
        if (Estructura::Hora_Trabajo_Inicio..Estructura::Hora_Trabajo_Fin).to_a.index(tiempo_actual.hour).present?
          horas_de_trabajo = (Estructura::Hora_Trabajo_Inicio..Estructura::Hora_Trabajo_Fin).to_a.index(12)
          minutos_de_trabajo = horas_de_trabajo * 60 #pasar las horas de trabajo a minutos trabajados para normalizar
          if (tiempo - minutos_de_trabajo) > 0
            tiempo = tiempo - minutos_de_trabajo #se resta el tiempo que se trabajara ese dia
          end
          dias_faltantes = tiempo / Estructura::Minutos_Dias #se vuelve a calcular el aproximado de dias
        else

          if tiempo_actual.hour < 7 #verificar si se pregunta en horas de la madrugada
            dias_faltantes += tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
          elsif tiempo_actual.hour > 15 #verificar si se pregunta en horas de la tarde
            dias_faltantes = 1.00
            dias_faltantes += tiempo.to_f / Estructura::Minutos_Dias.to_f #se vuelve a calcular el aproximado de dias
          end
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
      minutos_faltantes = '0.' + minutos_faltantes
      minutos_faltantes = minutos_faltantes.to_f
      minutos_faltantes *= Estructura::Minutos_Dias
      fecha_estimada = tiempo_actual + dias_faltantes.days #calcular la cantidad de dias
      fecha_entrega = DateTime.new(fecha_estimada.year, fecha_estimada.month, fecha_estimada.day, Estructura::Hora_Trabajo_Inicio) #se crea la nueva fecha con el tiempo a las 7am
      fecha_entrega = fecha_entrega + minutos_faltantes.minute #se suman los minutos faltantes para la entrega

      return fecha_entrega
    else
      return false
    end
  end

end
