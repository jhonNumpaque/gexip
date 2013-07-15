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
        @tipo = params[:informes][:tipo] if params[:informes][:tipo].present?
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
      resultado = resultado.where("cargo_escrutura_tarea_estructura_id = #{estructura}")
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

  
  #DEMANDA DE EXPEDIENTES
  def filtros_demanda

    fecha_inicio = params[:informes][:fecha_inicio] 
    fecha_fin = params[:informes][:fecha_fin] 
    cantidad = params[:informes][:cantidad_items]
    demanda = params[:informes][:demanda]
    proceso = params[:informes][:proceso]
    anho_inicio = params[:informes][:anho_inicio]
    anho_fin = params[:informes][:anho_fin]
    #   resultado = VistaProcesoDemandado
    resultado = VistaExpedienteProceso
    
    resultado = resultado.select("DISTINCT expediente_id, serieproceso_id")
    if fecha_inicio.present? && fecha_fin.present?
      resultado = resultado.where(:expediente_created_at => fecha_inicio .. fecha_fin)
    end
    
    #    case demanda
    #    when 'mayor'
    #      resultado = resultado.order("cant_expedientes desc")
    #    when 'menor'
    #      resultado = resultado.order("cant_expedientes asc")
    #    end
    
    if cantidad.present?
      resultado = resultado.limit(cantidad)
    end
    
    if proceso.present?
      resultado = resultado.where('serieproceso_id = ?',  proceso)
    end
    
    if anho_inicio.present? && anho_fin.present?
      anho_inicio = anho_inicio + '-01-01'
      anho_fin = anho_fin + '-01-01'
      resultado = resultado.where(:expediente_created_at => anho_inicio .. anho_fin)
    end
    
    p = {}
    resultado.each do |r|
      p[r.serieproceso_id] ||= [0,0]
      p[r.serieproceso_id][0] +=1
    end

    
    case demanda
    when 'mayor'
      p = p.sort{ |a,b| b[1] <=> a[1]}
    when 'menor'
      p = p.sort{ |a,b| a[1] <=> b[1]}
    end
    
    #    if demanda.present?    
    #      
    #      resultado = resultado.where(:created_at => fecha_inicio .. fecha_fin)
    #      case demanda
    #      when 'mayor'
    #        resultado = resultado.order("cant_expedientes desc")
    #      when 'menor'
    #        resultado = resultado.order("cant_expedientes asc")
    #      end
    #
    #      if cantidad.present?
    #        resultado = resultado.limit(cantidad)
    #      end
    #    
    #      puts resultado.all
    #      
    #    end
    #    
    #    #en caso que se haya elegido el proceso
    #    if proceso.present?
    #      resultado = resultado.where('id = ?',  proceso)
    #      
    #      #en caso que el anho fin sea menor que el anho inicio, el anho fin sera del mismo valor que el del anho inicio
    #      #      sql = "select count(expedientes) cantidad, tt.tiempo from ( "
    #      if anho_inicio.present? && anho_fin.present?
    #        if(anho_fin <= anho_inicio)
    #          anho_fin = anho_inicio
    #          #          sql += "select te.expediente_id as expedientes, to_char(sp.created_at, 'MM/yyyy') as tiempo"
    #        else
    #          # sql += "select te.expediente_id as expedientes, to_char(sp.created_at, 'yyyy') as tiempo "
    #        end
    #      end
    #    
    #      
    #      #concatenar para el inicio y el fin de los anhos
    #      fecha_inicio = anho_inicio + "-01-01"
    #      fecha_fin = anho_fin + "-01-01"
    #          
    #      #concatenar el sql
    #      #sql += "
    #      #  from expedientes sp, tareas_expedientes te, tareas t, actividades a, procedimientos p
    #      #	 where sp.id = te.expediente_id
    #      #	   and te.tarea_id = t.id
    #      #	   and t.actividad_id = a.id
    #      #	   and a.procedimiento_id = p.id
    #      #	   and sp.estado = 'FINALIZADO'
    #      #	   and sp.created_at between '#{fechainicio}' and '#{fechafin}' -- rango de fechaan
    #      #	   and p.serieproceso_id = #{proceso} -- proceso seleccionado
    #      #	 group by te.expediente_id, sp.created_at
    #      #	) tt
    #      #group by tt.tiempo 
    #      #order by tt.tiempo  asc;
    #      #      "
    #   
    #      resultado = resultado.where(:created_at => fecha_inicio .. fecha_fin)
      
    #  end
    
    
    #resultados = ActiveRecord::Base.connection.execute(sql).first
    return p

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

  
  #FILTRO DE EXPEDIENTES
  def filtros_resumen
    fecha_inicio = params[:informes][:fecha_inicio] 
    fecha_fin = params[:informes][:fecha_fin] 
    estado = params[:informes][:estado]
    tipo = params[:informes][:tipo]
    
    resultado = Expediente
    
    if tipo.present?
      resultado = resultado.select("count(id) as contador, EXTRACT(#{tipo} FROM created_at::timestamp::date) as fecha")
    else
      resultado = resultado.select("count(id) as contador, created_at::timestamp::date as fecha")
    end

    if estado.present?
      resultado = resultado.where('estado = ?', estado)
    end
    if fecha_inicio.present? && fecha_fin.present?
      if fecha_inicio > fecha_fin
        fecha_fin = fecha_inicio
      end
      
      resultado = resultado.where(:created_at => fecha_inicio .. fecha_fin)
    end
    case tipo
    when 'YEAR'
      resultado = resultado.group('EXTRACT(YEAR FROM created_at::timestamp::date)')
    when 'MONTH'
      resultado = resultado.group('EXTRACT(MONTH FROM created_at::timestamp::date), EXTRACT(YEAR FROM created_at::timestamp::date)')
    when 'DAY'
      resultado = resultado.group('EXTRACT(DAY FROM created_at::timestamp::date), EXTRACT(MONTH FROM created_at::timestamp::date), EXTRACT(YEAR FROM created_at::timestamp::date)')
    end
    
    
    return resultado
    
  end
  
end