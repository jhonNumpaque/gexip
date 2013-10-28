class InformesController < ApplicationController
  def index

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def vista_general
    vista = VistaExpedienteTotal
    vista = vista.select("DISTINCT expediente_id, macroproceso_id, macroproceso_nombre, ente_type")

    @anho = params[:anho].present? ? params[:anho] : nil
    vista = vista.where("TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') = ?", "#{params[:anho]}") if params[:anho].present?

    @porcentaje = {}
    vista.each do |v|
      @porcentaje[v.macroproceso_id] ||= {}
      @porcentaje[v.macroproceso_id][v.ente_type] ||= 0
      @porcentaje[v.macroproceso_id][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.macroproceso_id]["cantidad"] ||= 0
      @porcentaje[v.macroproceso_id]["cantidad"] += 1 #contar la cantidad total de expedientes por macroproceso
    end
    @macroprocesos = Macroproceso.all
    puts @porcentaje

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def show_macroproceso
    @macroproceso = Macroproceso.find(params[:id])
    vista = VistaExpedienteTotal
    vista = vista.select("DISTINCT expediente_id, macroproceso_id, macroproceso_nombre, ente_type, TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') as anho")
    vista = vista.where("macroproceso_id = ?", @macroproceso.id )
    vista = vista.order("anho ASC")

    @porcentaje = {}
    vista.each do |v|
      @porcentaje[v.anho] ||= {}
      @porcentaje[v.anho][v.ente_type] ||= 0
      @porcentaje[v.anho][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.anho]["cantidad"] ||= 0
      @porcentaje[v.anho]["cantidad"] += 1 #contar la cantidad de expedientes por anho
    end

    respond_to do |format|
      format.html
    end
  end

  def show_procesos
    @macroproceso = Macroproceso.find(params[:macroproceso_id])
    @procesos = Proceso.where('serieproceso_id = ?', params[:macroproceso_id])

    vista = VistaExpedienteTotal
    vista = vista.select("DISTINCT expediente_id, proceso_id, proceso_nombre, ente_type, TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') AS anho, TO_CHAR(expediente_fecha_creacion::timestamp, 'mm') AS mes")
    vista = vista.where("proceso_id in (?)", @procesos.map{ |v| v.id } )
    vista = vista.where("TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') = (?)", params[:anho] ) if params[:anho].present? #filtar el proceso por anho
    vista = vista.order("anho ASC, mes ASC")

    @porcentaje = {}
    vista.each do |v|
      @porcentaje[v.proceso_id] ||= {}
      #@porcentaje[v.proceso_id] ||= { 'anho' => { v.anho => { v.ente_type => 0, 'cantidad' => 0 }},
      #                                'mes' => { v.mes => { v.ente_type => 0, 'cantidad' => 0 }},
      #                                'trimestre' => { v.mes => { v.ente_type => 0, 'cantidad' => 0 }},
      #                                'semestre' => { v.mes => { v.ente_type => 0, 'cantidad' => 0 }},
      #                                'cuatrimestre' => { v.mes => { v.ente_type => 0, 'cantidad' => 0 }}}
      @porcentaje[v.proceso_id]['anho'] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho][v.ente_type] ||= 0
      @porcentaje[v.proceso_id]['anho'][v.anho][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.proceso_id]['anho'][v.anho]["cantidad"] ||= 0
      @porcentaje[v.proceso_id]['anho'][v.anho]["cantidad"] += 1
      @porcentaje[v.proceso_id]['anho'][v.anho] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['semestre'] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre'] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre'] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'][v.mes] ||= {}
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'][v.mes][v.ente_type] ||= 0
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'][v.mes][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'][v.mes]["cantidad"] ||= 0
      @porcentaje[v.proceso_id]['anho'][v.anho]['mes'][v.mes]["cantidad"] += 1 #contar la cantidad de expedientes por anho
      #semestre
      if v.mes.to_i <= 6
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['01'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['01'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['01']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 6
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['02'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['02']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['semestre']['02']["cantidad"] += 1
      end #end del if
      #trimestre
      if v.mes.to_i <= 3
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['01'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['01'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['01']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 3 and v.mes.to_i <= 6
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['02'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['02']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['02']["cantidad"] += 1
      elsif v.mes.to_i > 6 and v.mes.to_i <= 9
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['03'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['03'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['03'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['03']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['03']["cantidad"] += 1
      elsif v.mes.to_i > 9 and v.mes.to_i <= 12
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['04'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['04'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['04'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['04']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['trimestre']['04']["cantidad"] += 1
      end
      #cuatrimestre
      if v.mes.to_i <= 4
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['01'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['01'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['01']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 4 and v.mes.to_i <= 8
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['02'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['02']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['02']["cantidad"] += 1
      elsif v.mes.to_i > 8 and v.mes.to_i <= 12
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['03'] ||= {}
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['03'][v.ente_type] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['03'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['03']["cantidad"] ||= 0
        @porcentaje[v.proceso_id]['anho'][v.anho]['cuatrimestre']['03']["cantidad"] += 1
      end
      @porcentaje[v.proceso_id]["nombre"] = v.proceso_nombre
    end

    respond_to do |format|
      format.html
    end
  end

  def show_procedimientos
    @proceso = Proceso.find(params['proceso_id'])
    @macroproceso = Macroproceso.find(@proceso.serieproceso_id)

    vista = VistaExpedienteTotal
    vista = vista.select("DISTINCT expediente_id, proceso_id, proceso_nombre, procedimiento_id, procedimiento_nombre, ente_type, TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') AS anho, TO_CHAR(expediente_fecha_creacion::timestamp, 'mm') AS mes")
    vista = vista.where("proceso_id in (?)", @proceso.id )
     vista = vista.where("TO_CHAR(expediente_fecha_creacion::timestamp, 'YYYY') = (?)", params[:anho] ) if params[:anho].present? #filtar el proceso por anho
     vista = vista.order("anho ASC, mes ASC")

     @porcentaje = {}
     vista.each do |v|
      @porcentaje[v.procedimiento_id] ||= {}
      @porcentaje[v.procedimiento_id]['anho'] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho][v.ente_type] ||= 0
      @porcentaje[v.procedimiento_id]['anho'][v.anho][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.procedimiento_id]['anho'][v.anho]["cantidad"] ||= 0
      @porcentaje[v.procedimiento_id]['anho'][v.anho]["cantidad"] += 1
      @porcentaje[v.procedimiento_id]['anho'][v.anho] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre'] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre'] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre'] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'][v.mes] ||= {}
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'][v.mes][v.ente_type] ||= 0
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'][v.mes][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'][v.mes]["cantidad"] ||= 0
      @porcentaje[v.procedimiento_id]['anho'][v.anho]['mes'][v.mes]["cantidad"] += 1 #contar la cantidad de expedientes por anho
      #semestre
      if v.mes.to_i <= 6
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['01'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['01'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['01']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 6
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['02'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['02']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['semestre']['02']["cantidad"] += 1
      end #end del if
      #trimestre
      if v.mes.to_i <= 3
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['01'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['01'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['01']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 3 and v.mes.to_i <= 6
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['02'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['02']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['02']["cantidad"] += 1
      elsif v.mes.to_i > 6 and v.mes.to_i <= 9
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['03'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['03'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['03'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['03']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['03']["cantidad"] += 1
      elsif v.mes.to_i > 9 and v.mes.to_i <= 12
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['04'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['04'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['04'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['04']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['trimestre']['04']["cantidad"] += 1
      end
      #cuatrimestre
      if v.mes.to_i <= 4
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['01'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['01'][v.ente_type] ||= 0 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['01'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['01']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['01']["cantidad"] += 1
      elsif v.mes.to_i > 4 and v.mes.to_i <= 8
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['02'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['02'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['02'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['02']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['02']["cantidad"] += 1
      elsif v.mes.to_i > 8 and v.mes.to_i <= 12
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['03'] ||= {}
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['03'][v.ente_type] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['03'][v.ente_type] += 1 #contar la cantidad de expedientes por tipo de persona
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['03']["cantidad"] ||= 0
        @porcentaje[v.procedimiento_id]['anho'][v.anho]['cuatrimestre']['03']["cantidad"] += 1
      end
      @porcentaje[v.procedimiento_id]["nombre"] = v.procedimiento_nombre
    end

    respond_to do |format|
      format.html
    end
  end

  def show_expedientes

    @procedimiento = Procedimiento.find(params[:procedimiento_id])
    begin
      @proceso = Proceso.find(@procedimiento.serieproceso_id)
    rescue Exception => e
      puts e
    ensure
      @subproceso = Subproceso.find(@procedimiento.serieproceso_id)
      @proceso = Proceso.find(@subproceso.serieproceso_id)
    end

    @macroproceso = Macroproceso.find(@proceso.serieproceso_id)

    @vista = VistaExpedienteTotal.select("expediente_id, expediente_fecha_creacion, TO_CHAR(expediente_fecha_creacion, 'YYYY') as anho, TO_CHAR(expediente_fecha_creacion, 'mm') as mes, expediente_estado, ente_nombre, ente_apellido, ente_type, expediente_fecha_finalizo, usuario_inicio, expediente_numero, tarea_expediente_fecha_inicio, tarea_expediente_fecha_fin")
    @vista = @vista.where("procedimiento_id = ?", @procedimiento.id)
    @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'YYYY') = ?", params['anho']) if params['anho'].present?
    @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') = ?", params['mes']) if params['mes'].present?
    @vista = @vista.where("expediente_estado = ?", params['estado']) if params['estado'].present?
    @vista = @vista.where("ente_id = ?", params['cliente']) if params['cliente'].present?
    @vista = @vista.where("ente_type = ?", params['tipo_cliente']) if params['tipo_cliente'].present?
    @vista = @vista.where("usuario_inicio = ?", params['funcionario']) if params['funcionario'].present?
    #seleccionar semestre
    if params['semestre'].present?
      case params['semestre']
      when '01'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') <= ? ", '06')
      when '02'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? ", '06')
      end
    end
    #seleccionar trimestre
    if params['trimestre'].present?
      case params['trimestre']
      when '01'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') <= ? ", '03')
      when '02'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? AND to_char(expediente_fecha_creacion, 'mm') <= ? ", '03', '06')
      when '03'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? AND to_char(expediente_fecha_creacion, 'mm') <= ? ", '06', '09')
      when '04'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? ", '09')
      end
    end
    #seleccionar cuatrimestre
    if params['cuatrimestre'].present?
      case params['cuatrimestre']
      when '01'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') <= ? ", '04')
      when '02'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? AND to_char(expediente_fecha_creacion, 'mm') <= ? ", '04', '08')
      when '03'
        @vista = @vista.where("TO_CHAR(expediente_fecha_creacion, 'mm') > ? ", '08')
      end
    end

    @vista = @vista.order("expediente_fecha_creacion ASC")
    #obtener el tiempo total que se lleva a cabo en el expediente REVISAR
    @resultado = {}
    @vista.each do |v|
      @resultado[v.expediente_id] ||= {}
      @resultado[v.expediente_id]["expediente_fecha_creacion"] ||= v.expediente_fecha_creacion
      @resultado[v.expediente_id]["expediente_fecha_finalizo"] ||= v.expediente_fecha_finalizo
      @resultado[v.expediente_id]["expediente_numero"] ||= v.expediente_numero
      @resultado[v.expediente_id]["expediente_estado"] ||= v.expediente_estado
      @resultado[v.expediente_id]["ente_nombre"] ||= v.ente_nombre
      @resultado[v.expediente_id]["ente_apellido"] ||= v.ente_apellido
      @resultado[v.expediente_id]["ente_type"] ||= v.ente_type
      @resultado[v.expediente_id]["usuario_inicio"] ||= v.usuario_inicio
      @resultado[v.expediente_id]["expediente_fecha_creacion"] = v.expediente_fecha_creacion
      @resultado[v.expediente_id]["expediente_fecha_creacion"] = v.expediente_fecha_creacion
      if v.tarea_expediente_fecha_fin.present?
        @resultado[v.expediente_id]["duracion"] += ((v.tarea_expediente_fecha_fin.to_datetime - v.tarea_expediente_fecha_inicio.to_datetime) * 24 * 60 ).to_i
      elsif
        @resultado[v.expediente_id]["duracion"] = 0
      end


    end

    @usuarios = Usuario.find(@vista.map{ |v| v.usuario_inicio })

    respond_to do |format|
      format.html
    end
  end

  def show_tareas
    @vista = VistaExpedienteTotal
    @vista = @vista.select("DISTINCT tarea_expediente_id, tarea_nombre, tarea_expediente_fecha_inicio, tarea_expediente_fecha_fin, tarea_expediente_usuario_inicio, tarea_expediente_usuario_fin, tarea_expediente_estado, procedimiento_id, procedimiento_nombre")
    @vista = @vista.where('expediente_id = ?', params[:expediente_id])

    @expediente = Expediente.find(params[:expediente_id])
    @procedimiento = Procedimiento.find(@expediente.tareas.first.actividad.procedimiento.id)

    begin
      @proceso = Proceso.find(@procedimiento.serieproceso_id)
    rescue Exception => e
      puts e
    ensure
      @subproceso = Subproceso.find(@procedimiento.serieproceso_id)
      @proceso = Proceso.find(@subproceso.serieproceso_id)
    end

    @macroproceso = Macroproceso.find(@proceso.serieproceso_id)

    respond_to do |format|
      format.html
    end

  end

  def form_demora
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def form_demanda
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def form_radicados
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def form_anulados
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def show_demanda
    @fecha_inicio = params[:informes].present? ? params[:informes][:fecha_inicio] : nil
    @fecha_fin = params[:informes].present? ? params[:informes][:fecha_fin] : nil
    @formato = params[:informes].present? ? params[:informes][:formato] : nil
    cantidad = params[:informes].present? ? params[:informes][:cantidad] : nil
    demanda = params[:informes].present? ? params[:informes][:demanda] : nil
    procedimiento = params[:informes].present? ? params[:informes][:procedimiento] : nil
    modo_duracion = params[:informes].present? ? params[:informes][:modo_duracion] : nil
    cant_duracion = params[:informes].present? ? params[:informes][:cant_duracion] : nil
    unidad_duracion = params[:informes].present? ? params[:informes][:unidad_duracion] : nil
    #   resultado = VistaProcesoDemandado
    vista_expediente_proceso = VistaExpedienteProceso
    vista_procedimiento_tiempo = VistaProcedimientoTiempo
    @resultados = {}
    duracion = 0


    if @formato.present?
      case @formato
      when 'meses'
        format = 'MM'
      when 'semanas'
        format = 'W'
      when 'dias'
          #formato para los dias del anho, no dias del mes
          format = 'DD'
        end
      else
        format = 'DD-MM-YYYY'
      end

    #realiza el selec con el formato de fecha seleccionado
    vista_expediente_proceso = vista_expediente_proceso.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, '#{format}') as created_at, expediente_created_at, procedimiento_id")
    if @fecha_inicio.present? && @fecha_fin.present?
      vista_expediente_proceso = vista_expediente_proceso.where(:expediente_created_at => @fecha_inicio .. @fecha_fin)
    end

    #verifica por tiempo de duracion
    if cant_duracion.present? && unidad_duracion.present?
      #normalizar a minutos la duracion
      case unidad_duracion
      when 'minutos'
        duracion = cant_duracion.to_i
      when 'horas'
        duracion = cant_duracion.to_i * 60
      when 'dias'
        duracion = cant_duracion.to_i * Estructura::Minutos_Dias
      when 'semanas'
        duracion = cant_duracion.to_i * Estructura::Minutos_Semana
      when 'meses'
        duracion = cant_duracion.to_i * Estructura::Minutos_Mes
      end

      puts duracion


      if modo_duracion.present?
        case modo_duracion
        when 'mayor'
          vista_procedimiento_tiempo = vista_procedimiento_tiempo.where('tiempo > ?', duracion)
        when 'menor'
          vista_procedimiento_tiempo = vista_procedimiento_tiempo.where('tiempo < ?', duracion)
        when 'igual'
          vista_procedimiento_tiempo = vista_procedimiento_tiempo.where(:tiempo => duracion)
        end
      else
        vista_procedimiento_tiempo = vista_procedimiento_tiempo.where(:tiempo => duracion).all
      end
      procedimiento_array = vista_procedimiento_tiempo.map{ |t| t.id}
    end

    #verifica si es que el proceso se encuentra
    if procedimiento.present?
      vista_expediente_proceso = vista_expediente_proceso.where(:procedimiento_id => procedimiento)
      @procedimiento = Procedimiento.find(procedimiento)
    elsif procedimiento_array.present?
      vista_expediente_proceso = vista_expediente_proceso.where(:procedimiento_id => procedimiento_array)
    end

    #suman la cantidad de expedientes agrupados por la fecha de creacion
    p = {}

    vista_expediente_proceso.each do |r|
      p[r.procedimiento_id] ||= {}
      p[r.procedimiento_id][r.created_at.to_i] ||= [0, 0]
      p[r.procedimiento_id][r.created_at.to_i][0] += 1
      p[r.procedimiento_id][r.created_at.to_i][1] = r.expediente_created_at.to_s
    end

    #busca el objeto Proceso
    #if proceso.present?
      #@proceso = Proceso.find(proceso)
    #end

    if demanda.present?
      #sumar la cantidad total de expedientes
      total = {}
      orden = {}
      p.each do |k, r|
        total[k] = r.map { |k, v| v[0] }.inject(0) { |sum, k| sum + k }
      end

      case demanda
      when 'mayor'
          #devuelve un array de arrays [[key, val], [key, val]]
          aux = total.sort { |a, b| b[1] <=> a[1] }
        when 'menor'
          #devuelve un array de arrays [[key, val], [key, val]]
          aux = total.sort { |a, b| a[1] <=> b[1] }
        end
      #coloca los valores dentro de orden
      aux.map { |v| orden[v[0]] = v[1] }
    end

    if cantidad.present?
      count = 1
      if orden.present?
        orden.each do |k, v|
          if count <= cantidad.to_i
            @resultados[k] = p[k]
          end
          count += 1
        end
      else
        @resultados = {}
        p.each do |k, r|
          if count <= cantidad.to_i
            @resultados[k] = r
          end
          count += 1
        end
      end

    else
      if orden.present?
        orden.each do |k, v|
          @resultados[k] = p[k]
        end
      else
        @resultados = p
      end
    end

    respond_to do |format|
      format.html # show.html.erb
    end

  end

  def show_rendimiento
    @fecha_inicio = params[:informes].present? ? params[:informes][:fecha_inicio] : nil
    @fecha_fin = params[:informes].present? ? params[:informes][:fecha_fin] : nil
    @funcionario = params[:informes].present? ? params[:informes][:funcionario] : nil #recibe siempre un campo vacio ["", "2"]
    @formato = params[:informes].present? ? params[:informes][:formato] : nil
    resultado = VistaExpedienteProceso

    if @formato.present?
      case @formato
      when 'meses'
        format = 'MM'
      when 'semanas'
        format = 'W'
      when 'dias'
          #formato para los dias del anho, no dias del mes
          format = 'DDD'
        end
      else
        format = 'DD-MM-YYYY'
      end

      resultado = resultado.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, '#{format}') as created_at, expediente_created_at, tarea_expediente_usuario_inicio as usuario_id")

      if @funcionario.size >= 2
        array_id = []
        @funcionario.each do |f|
          usuario = Usuario.where(:funcionario_id => f).first
        #verificar que el usuario exista
        if usuario.present?
          array_id.push(usuario.id.to_s)
        end
      end
      resultado = resultado.where("tarea_expediente_usuario_inicio in (" + array_id.join(",") + ")")
    end

    if @fecha_inicio.present? && @fecha_fin.present?
      resultado = resultado.where(:expediente_created_at => @fecha_inicio .. @fecha_fin)
    end

    #suman la cantidad de expedientes agrupados por la fecha de creacion
    p = {}
    #establecer los valores para los usuarios, para mostrar en la tabla
    array_id.each do |u|
      p[u] ||= {}
    end

    resultado.each do |r|
      p[r.usuario_id][r.created_at.to_i] ||= [0, 0, 0, 0]
      p[r.usuario_id][r.created_at.to_i][0] += 1
      p[r.usuario_id][r.created_at.to_i][1] = r.expediente_created_at
    end

    @resultados = p

    puts @resultados

    respond_to do |format|
      format.html # show.html.erb
    end

  end

  def show_radicados
    @anho = params[:informes].present? ? params[:informes][:anho] : nil
    @procedimiento = params[:informes].present? ? params[:informes][:procedimiento] : nil
    resultado = VistaExpedienteProceso

    #agrupar por meses de entrada
    resultado = resultado.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, 'MM') as created_at, TO_CHAR(expediente_fecha_finalizo::timestamp, 'MM') as fecha_finalizo, expediente_created_at, expediente_fecha_finalizo, expediente_estado")

    if @anho.present?
      resultado = resultado.where("TO_CHAR(expediente_created_at::timestamp, 'YYYY') = '#{@anho}'")
    end

    if @procedimiento.present?
      resultado = resultado.where(:procedimiento_id => @procedimiento)
    end

    #agrupar la cantidad de epxedientes que se dieron por mesa de entrada en el mes
    p = {
      1 => [0, 0, 0, 0, 0],
      2 => [0, 0, 0, 0, 0],
      3 => [0, 0, 0, 0, 0],
      4 => [0, 0, 0, 0, 0],
      5 => [0, 0, 0, 0, 0],
      6 => [0, 0, 0, 0, 0],
      7 => [0, 0, 0, 0, 0],
      8 => [0, 0, 0, 0, 0],
      9 => [0, 0, 0, 0, 0],
      10 => [0, 0, 0, 0, 0],
      11 => [0, 0, 0, 0, 0],
      12 => [0, 0, 0, 0, 0]
    }
    anulados = {}
    finalizados = {}
    resultado.each do |r|
      p[r.created_at.to_i][0] ||= 0
      #sumar la cantidad de expedientes que pasaron por mesa de entrada
      p[r.created_at.to_i][0] += 1

      case r.expediente_estado
      when 'FINALIZADO'
        p[r.fecha_finalizo.to_i][1] ||= 0
        p[r.fecha_finalizo.to_i][1] += 1
          finalizados[r.expediente_id] ||= [0, 0, 0, 0] # [fecha_creacion, fecha_finalizo, tiempo_total, exedente]
          finalizados[r.expediente_id][0] = r.created_at.to_i
          finalizados[r.expediente_id][1] = r.fecha_finalizo.to_i
        when 'ANULADO'
          p[r.fecha_finalizo.to_i][2] ||= 0
          p[r.fecha_finalizo.to_i][2] += 1
          anulados[r.expediente_id] ||= [0, 0]
          anulados[r.expediente_id][0] = r.created_at.to_i
          anulados[r.expediente_id][1] = r.fecha_finalizo.to_i
        else
          p[r.created_at.to_i][3] ||= 0
          p[r.created_at.to_i][3] += 1
        end
      end

    #realizar el porcentaje de documentos radicados. formula: (expedientes finalizado / expedientes recepcionados) * 100
    p.each do |k, v|
      if p[k][0].to_i > 0 && p[k][1].to_i > 0
        p[k][4] = (p[k][1].to_i / p[k][0].to_i) * 100
      end
    end


    #seleccionar la suma del tiempo total de ejecucion de todas las tareas realizadas a cada expediente
    vista_procedimiento_tiempo = VistaProcedimientoTiempo.where(:id => @procedimiento).first
    tarea_expediente = TareaExpediente.where(:expediente_id => finalizados.keys)
    #sumar el total de minutos que toma el expediete
    tarea_expediente.each do |t|
      minutos = t.tiempo_ejecucion_normalizado
      finalizados[t.expediente_id][2] += minutos
    end
    #comprar el total de minutos que tomo el expediente con el estimado
    finalizados.each do |k, v|
      #puts vista_procedimiento_tiempo.tiempo
      finalizados[k][3] = v[2] - vista_procedimiento_tiempo.tiempo
      #finalizados[k][3] = v[2]
    end

    #asignar al mes de creacion los que terminaron en tiempo y los que tuvieron retrasos
    @finalizados = {}
    finalizados.each do |k, v|
      @finalizados[v[0]] ||= [0, 0]
      if v[3] > 0
        @finalizados[v[0]][0] += 1
      elsif v[3] <= 0
        @finalizados[v[0]][1] += 1
      end
    end

    #asignar al mes de creacion los anulados
    @anulados = {}
    anulados.each do |k, v|
      @anulados[v[0]] ||= 0
      @anulados[v[0]] += 1
    end


    #datos para mostrar
    @finalizados

    @resultados = p

    respond_to do |format|
      format.html # show.html.erb
    end

  end

end