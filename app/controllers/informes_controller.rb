class InformesController < ApplicationController
  def index
  end

  def mostrar_formulario

    @tipo_informe = params[:tipo_informe]

    if params[:informes].present?
      filtro = params[:informes][:filtro]
      case filtro
        when "promedios"
          @resultados = filtros_promedio
          @fecha_inicio = params[:informes][:fecha_inicio]
          @fecha_fin = params[:informes][:fecha_fin]
          @estructura = Estructura.find(params[:informes][:estructura]) if params[:informes][:estructura].present?
          @proceso = Proceso.find(params[:informes][:proceso]) if params[:informes][:proceso].present?
          @procedimiento = Procedimiento.find(params[:informes][:procedimiento]) if params[:informes][:procedimiento].present?
        when "demanda"
          @resultados = filtros_demanda
        when "demora"
          @resultados = filtros_demora
        when "resumen"
          @resultados = filtros_resumen
          @tipo = params[:informes][:tipo]
          @fecha_inicio = params[:informes][:fecha_inicio]
          @fecha_fin = params[:informes][:fecha_fin]
        when "rendimiento"

        else
          puts filtro
      end
    end

    #realizar los calculos de los anhos transcurridos desde el primer expediente
    primer_anho = Expediente.order('id ASC').first
    primer_anho = primer_anho.created_at.year.to_i
    anho_actual = Time.now
    anho_actual = anho_actual.strftime("%Y").to_i

    @rango_anhos = Hash.new
    while primer_anho <= anho_actual
      key = primer_anho.to_s
      @rango_anhos[key] = primer_anho
      primer_anho += 1
    end

    respond_to do |format|
      if @resultados.present?
        format.html # index.html.erb
        format.json { render json: @tipo_informe }
      else
        format.html
      end
    end
  end

  #PROMEDIO DE EXPEDIENTES
  def filtros_promedio
    fecha_inicio = params[:informes][:fecha_inicio]
    fecha_fin = params[:informes][:fecha_fin]
    estructura = params[:informes][:estructura]
    proceso = params[:informes][:proceso]
    procedimiento = params[:informes][:procedimiento]

    #    fecha_inicio = fecha_inicio.to_date.strftime('%Y-%m-%d')
    #    fecha_fin = fecha_fin.to_date.strftime('%Y-%m-%d')

    resultado = VistaExpedienteProceso

    if proceso.present?
      resultado = resultado.where("serieproceso_id  = #{proceso}")
    end

    if estructura.present?
      resultado = resultado.where("tarea_cargo_estructura = #{estructura}")
    end

    if procedimiento.present?
      resultado = resultado.where("procedimiento_id = #{procedimiento}")
    end

    resultado = resultado.where("expediente_estado = 'FINALIZADO'")
    resultado = resultado.where(:expediente_created_at => fecha_inicio .. fecha_fin)

    if resultado.present?
      p = {}
      resultado.each do |r|
        p[r.expediente_id] ||= [0, 0]
        p[r.expediente_id][0] += (r.expediente_fecha_finalizo.to_datetime - r.expediente_created_at.to_datetime).to_i
      end

      dias = p.map { |id, hash| hash[0] }

      result = {}
      result['dias'] = (dias.inject { |aux, x| aux + x }).to_i / p.size.to_i
      result['cantidad'] = p.size

    else
      result = {}
      result['dias'] = 0
      result['cantidad'] = 0
    end

    return result
  end


  #DEMORA DE EXPEDIENTES
  def filtros_demora
    fecha_inicio = params[:informes][:fecha_inicio]
    fecha_fin = params[:informes][:fecha_fin]
    tipo = params[:informes][:tipo]
    usuario = params[:informes][:usuario]
    estructura = params[:informes][:estructura]
    cargo = params[:informes][:cargo]

    resultado = VistaExpedienteProceso

    if tipo == "culminado"
      resultado = resultado.where("expediente_estado = 'FINALIZADO'")
    elsif tipo == "no_culminado"
      resultado = resultado.where("expediente_estado <> 'FINALIZADO'")
      resultado = resultado.where("expediente_estado <> 'ENTREGADO'")
    end

    if usuario.present?
      resultado = resultado.where(:tarea_expediente_usuario_inicio => usuario)
    end

    if estructura.present? && cargo.present?
      cargo_estructura = CargoEstructura.where(:cargo_id => cargo, :estructura_id => estructura).first
      resultado = resultado.where(:tarea_cargo_estructura => cargo_estructura.id)
    end

    resultado = resultado.where(:expediente_created_at => fecha_inicio .. fecha_fin)


    if resultado.present?
      p = {}
      resultado.each do |r|
        #        p[r.expediente_id] ||= ['dias', 'usuario_id']
        p[r.expediente_id] ||= [0, 0]
        if tipo == "culminado"
          p[r.expediente_id][0] += (r.expediente_fecha_finalizo.to_datetime - r.expediente_created_at.to_datetime).to_i
        elsif tipo == "no_culminado"
          if p[r.expediente_id][0].present? || p[r.expediente_id][0] < r.expediente_created_at.to_datetime
            p[r.expediente_id][0] = r.expediente_created_at.to_datetime
          end
          p[r.expediente_id][1] = r.tarea_expediente_usuario_inicio
          p[r.expediente_id][2] = r.procedimiento_id
          p[r.expediente_id][3] = r.tarea_cargo_estructura
        end
      end


      result = {}
      if tipo == "culminado"
        resultado.each do |r|
          result[r.expediente_id] ||= [0, 0]
          dias = p.map { |id, hash| hash[0] }
          result[r.expediente_id][0] = (dias.inject { |aux, x| aux + x }).to_i / p.size.to_i
          result[r.expediente_id][1] = r.tarea_expediente_usuario_fin
          result[r.expediente_id][2] = r.procedimiento_id
          result[r.expediente_id][3] = r.tarea_cargo_estructura
        end
      elsif tipo == "no_culminado"
        resultado.each do |r|
          result[r.expediente_id] ||= [0, 0]
          result[r.expediente_id][0] = (r.expediente_fecha_finalizo.to_datetime - p[r.expediente_id][0]).to_i
          result[r.expediente_id][1] = p[r.expediente_id][1]
          result[r.expediente_id][2] = p[r.expediente_id][2]
          result[r.expediente_id][3] = p[r.expediente_id][3]
        end
      end
    else
      result = {}
      result['dias'] = 0
      result['cantidad'] = 0
    end

    return result
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
    @fecha_inicio = params[:informes][:fecha_inicio]
    @fecha_fin = params[:informes][:fecha_fin]
    @formato = params[:informes][:formato]
    cantidad = params[:informes][:cantidad]
    demanda = params[:informes][:demanda]
    #proceso = params[:informes][:proceso]
    procedimiento = params[:informes][:procedimiento]
    modo_duracion = params[:informes][:modo_duracion]
    cant_duracion = params[:informes][:cant_duracion]
    unidad_duracion = params[:informes][:unidad_duracion]
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
    vista = vista_expediente_proceso.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, '#{format}') as created_at, expediente_created_at, procedimiento_id")
    if @fecha_inicio.present? && @fecha_fin.present?
      vista = vista.where(:expediente_created_at => @fecha_inicio .. @fecha_fin)
    end

    #verifica por tiempo de duracion
    if cant_duracion.present? && unidad_duracion.present?
      #normalizar a minutos la duracion
      case unidad_duracion
        when 'minutos'
          duracion = cant_duracion.to_i
        when 'horas'
          duracion = cant_duracion.to_i / 60
        when 'dias'
          duracion = cant_duracion.to_i / Estructura::Minutos_Dias
        when 'semanas'
          duracion = cant_duracion.to_i / Estructura::Minutos_Semana
        when 'meses'
          duracion = cant_duracion.to_i / Estructura::Minutos_Mes
      end


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
      vista = vista.where('procedimiento_id = ?', procedimiento)
      @procedimiento = Procedimiento.find(procedimiento)

    elsif procedimiento_array.present?
      vista = vista.where(:procedimiento_id => procedimiento_array)
    end

    #suman la cantidad de expedientes agrupados por la fecha de creacion
    p = {}
    vista.each do |r|
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
    @fecha_inicio = params[:informes][:fecha_inicio]
    @fecha_fin = params[:informes][:fecha_fin]
    @funcionario = params[:informes][:funcionario] #recibe siempre un campo vacio ["", "2"]
    @formato = params[:informes][:formato]
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
    @anho = params[:informes][:anho]
    @procedimiento = params[:informes][:procedimiento]
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

  def show_anulados

    @anho = params[:informes][:anho]
    @procedimiento = params[:informes][:procedimiento]
    resultado = VistaExpedienteProceso
    @estructuras = Estructura.all

    #agrupar por meses de entrada
    resultado = resultado.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, 'MM') as created_at, expediente_estado, MAX(tarea_expediente_id) AS tarea_expediente, tarea_id, tarea_expediente_usuario_fin AS usuario_fin, cargo_estructura_tarea_cargo_id AS cargo_estructura_id")

    if @anho.present?
      resultado = resultado.where("TO_CHAR(expediente_created_at::timestamp, 'YYYY') = '#{@anho}'")
    end

    if @procedimiento.present?
      resultado = resultado.where(:procedimiento_id => @procedimiento, :expediente_estado => 'ANULADO').group("expediente_id, created_at, expediente_estado, tarea_id, usuario_fin, cargo_estructura_id")
    end

    p = {}
    resultado.each do |r|
      p[r.created_at.to_i] ||= {} #[cantidad, tarea_expediente_id]
                                  #sumar la cantidad de expedientes que se anularon en la dependencia
      @estructuras.each do |e|
        p[r.created_at.to_i][e.id] ||= 0
      end
    end

    #determinar por dependencias en donde se realizo la ultima tarea
    @resultados = p

    respond_to do |format|
      format.html # show.html.erb
    end

  end

end