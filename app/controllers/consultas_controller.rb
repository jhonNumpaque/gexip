class ConsultasController < ApplicationController
  layout "consultas"

  def index
    respond_to do |format|
      format.html { render layout: "formulario_consultas" } # show.html.erb
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def verificar_expediente
    documento = params[:documento]
    password = params[:password]

    @expediente = Expediente.where(:numero => documento, :clave => password)
    if @expediente.present?
      @expediente = @expediente.first
      #seleccionar las tareas ya realizadas en el expediente
      @tareas_expedientes = TareaExpediente.where(:expediente_id => @expediente.id)
      @tareas_expedientes = @tareas_expedientes.order("created_at DESC")

      #seleccionar las tareas que deben realizarse al expediente
      tarea_expediente = TareaExpediente.where(:expediente_id => @expediente.id).first
      actividades = Actividad.where(:procedimiento_id => tarea_expediente.tarea.actividad.procedimiento.id).all
      @tareas = Tarea.where("actividad_id IN (#{actividades.map { |f| f.id }.join(',')})  AND id NOT IN (#{@tareas_expedientes.map { |f| f.tarea_id }.join(',')})").all

      #obtener la suma en minutos del tiempo restante
      tiempo = 0
      @tareas.each do |t|
        tiempo += t.tiempo_normalizado.to_i
      end
      #calcular el dia de la entrega aproximada del expediente
      @tiempo_entrega = Procedimiento.calcular_fecha_entrega tiempo
    end


    respond_to do |format|
      if @expediente.present?
        format.html { render action: "show" }
      else
        format.html { redirect_to consultas_url, :flash => {:error => "Datos Inocorrectos!"} }
      end
    end

  end

  def desplegar_expediente
    documento = params[:documento]
    id = params[:id]

    @expediente = Expediente.where(:numero => documento, :id => id)
    if @expediente.present?
      @expediente = @expediente.first
      #seleccionar las tareas ya realizadas en el expediente
      @tareas_expedientes = TareaExpediente.where(:expediente_id => @expediente.id)
      @tareas_expedientes = @tareas_expedientes.order("created_at DESC")

      #seleccionar las tareas que deben realizarse al expediente
      tarea_expediente = TareaExpediente.where(:expediente_id => @expediente.id).first
      actividades = Actividad.where(:procedimiento_id => tarea_expediente.tarea.actividad.procedimiento.id).all
      @tareas = Tarea.where("actividad_id IN (#{actividades.map { |f| f.id }.join(',')})  AND id NOT IN (#{@tareas_expedientes.map { |f| f.tarea_id }.join(',')})").all

      #obtener la suma en minutos del tiempo restante
      tiempo = 0
      @tareas.each do |t|
        tiempo += t.tiempo_normalizado.to_i
      end
      #calcular el dia de la entrega aproximada del expediente
      @tiempo_entrega = Procedimiento.calcular_fecha_entrega tiempo
    end


    respond_to do |format|
      if @expediente.present?
        format.html { render action: "expediente_desplegado" }
      else
        format.html { redirect_to consultas_url, :flash => {:error => "Datos Inocorrectos!"} }
      end
    end

  end

end
