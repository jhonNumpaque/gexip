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
        p[r.expediente_id] ||= [0,0]
        p[r.expediente_id][0] += (r.expediente_fecha_finalizo.to_datetime - r.expediente_created_at.to_datetime).to_i
      end

      dias = p.map{ |id, hash| hash[0]}

      result = {}
      result['dias'] = (dias.inject{ |aux,x| aux + x  }).to_i / p.size.to_i
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
        p[r.expediente_id] ||= [0,0]
        if tipo == "culminado"
          p[r.expediente_id][0] += (r.expediente_fecha_finalizo.to_datetime - r.expediente_created_at.to_datetime).to_i
        elsif tipo == "no_culminado"         
          if p[r.expediente_id][0].present? || p[r.expediente_id][0] <  r.expediente_created_at.to_datetime
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
          result[r.expediente_id] ||= [0,0]
          dias = p.map{ |id, hash| hash[0]}
          result[r.expediente_id][0] = (dias.inject{ |aux,x| aux + x  }).to_i / p.size.to_i
          result[r.expediente_id][1] = r.tarea_expediente_usuario_fin
          result[r.expediente_id][2] = r.procedimiento_id
          result[r.expediente_id][3] = r.tarea_cargo_estructura
        end
      elsif tipo == "no_culminado"
        resultado.each do |r|
          result[r.expediente_id] ||= [0,0]
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
  
  def show_demanda
    @fecha_inicio = params[:informes][:fecha_inicio] 
    @fecha_fin = params[:informes][:fecha_fin] 
    @formato = params[:informes][:formato] 
    cantidad = params[:informes][:cantidad]
    demanda = params[:informes][:demanda]
    proceso = params[:informes][:proceso]
    #   resultado = VistaProcesoDemandado
    vista = VistaExpedienteProceso
    @resultados = {}
    
    
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

    #realiza el selec con el formato de fecha seleccionado
    vista = vista.select("DISTINCT expediente_id, TO_CHAR(expediente_created_at::timestamp, '#{format}') as created_at, expediente_created_at, proceso_id")
    if @fecha_inicio.present? && @fecha_fin.present?
      vista = vista.where(:expediente_created_at => @fecha_inicio .. @fecha_fin)
    end
    
    #verifica si es que el proceso se encuentra
    if proceso.present?
      vista = vista.where('proceso_id = ?',  proceso)
    end
    
    #suman la cantidad de expedientes agrupados por la fecha de creacion
    p = {}
    vista.each do |r|
      p[r.proceso_id] ||= {}
      p[r.proceso_id][r.created_at.to_i] ||= [0,0]
      p[r.proceso_id][r.created_at.to_i][0] += 1
      p[r.proceso_id][r.created_at.to_i][1] = r.expediente_created_at.to_s 
    end
    
    #busca el objeto Proceso
    if proceso.present?
      @proceso = Proceso.find(proceso)
    end

    if demanda.present?
      #sumar la cantidad total de expedientes
      total = {}
      orden = {}
      p.each do |k, r|
        total[k] = r.map{ |k, v| v[0] }.inject(0){|sum,k| sum + k } 
      end

      case demanda
      when 'mayor'
        #devuelve un array de arrays [[key, val], [key, val]]
        aux = total.sort{ |a, b| b[1] <=> a[1] }
      when 'menor'
        #devuelve un array de arrays [[key, val], [key, val]]
        aux = total.sort{ |a, b| a[1] <=> b[1] }
      end
        #coloca los valores dentro de orden
        aux.map{|v| orden[v[0]] = v[1]}
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
      p[r.usuario_id][r.created_at.to_i] ||= [0,0,0,0]
      p[r.usuario_id][r.created_at.to_i][0] += 1
      p[r.usuario_id][r.created_at.to_i][1] = r.expediente_created_at
    end

    @resultados = p

    puts @resultados

    respond_to do |format|
      format.html # show.html.erb     
    end

  end
  
end