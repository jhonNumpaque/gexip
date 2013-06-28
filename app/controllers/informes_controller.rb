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

      else
        puts filtro
      end
    end

    case @tipo_informe
    when 'demanda'
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

  def filtros_promedio
    fecha_inicio = params[:informes][:fecha_inicio]	
    fecha_fin = params[:informes][:fecha_fin]	
    estructura = params[:informes][:estructura]	
    proceso = params[:informes][:proceso]	
    procedimiento = params[:informes][:procedimiento]

    if fecha_inicio.present? and fecha_fin.present?
      sql = "select sum(t.tiempo)/count(t.tiempo) promedio, count(t.tiempo)  cantidad_expedientes
            from (
               select ex.fecha_finalizo - ex.created_at tiempo
               from expedientes ex
               where ex.estado = 'FINALIZADO'
               and ex.created_at between '"+fecha_inicio+"' and '"+fecha_fin+"' -- rango de fechaan
      "

      if estructura.present?
        sql += "and ex.id in (
                     select te.expediente_id
                     from estructuras e, cargos_estructuras ce, funcionarios f, usuarios u, tareas_expedientes te
                     where e.id = "+estructura+"
                     and e.id = ce.estructura_id
                     and ce.id = f.cargo_estructura_id
                     and f.id = u.funcionario_id
                     and (te.usuario_inicio_id = u.id or te.usuario_fin_id = u.id)
                     )"
      end

      if procedimiento.present?
        sql += "and ex.id in (
      select te.expediente_id
      from tareas_expedientes te, tareas t, actividades a, procedimientos p
      where te.tarea_id = t.id
      and t.actividad_id = a.id
      and a.procedimiento_id = p.id
      and p.id = #{procedimiento}
      )"
      end

      if proceso.present? 
        sql += "and ex.id in (
      select te.expediente_id
      from tareas_expedientes te, tareas t, actividades a, procedimientos p
      where te.tarea_id = t.id
      and t.actividad_id = a.id
      and a.procedimiento_id = p.id
      and p.serieproceso_id in (
         select sp.id from serieprocesos sp
         where sp.id = #{proceso}
         union
         select sp.id from serieprocesos sp
         where sp.serieproceso_id = #{proceso}
         )
)"
      end

      sql += ") t;"


      @expedientes = ActiveRecord::Base.connection.execute(sql).first
      return @expedientes
    end
  end

  def filtros_demanda

    fecha_inicio = params[:informes][:fecha_inicio] 
    fecha_fin = params[:informes][:fecha_fin] 
    cantidad = params[:informes][:cantidad_items]
    demanda = params[:informes][:demanda]
    proceso = params[:informes][:proceso]
    anho_inicio = params[:informes][:anho_inicio]
    anho_fin = params[:informes][:anho_fin]


    

   
    if demanda.present?
      
      sql = "select sp.nombre, sp.codigo, count(ex.expedientes) cant_expedientes
  from serieprocesos sp, expedientes esp, (
					    select te.expediente_id as expedientes, p.serieproceso_id as procesos
					      from tareas_expedientes te, tareas t, actividades a, procedimientos p
					     where te.tarea_id = t.id
					       and t.actividad_id = a.id
					       and a.procedimiento_id = p.id
					     group by te.expediente_id, p.serieproceso_id
					   ) ex
 where ex.procesos = sp.id
   and esp.id = ex.expedientes
   and esp.estado = 'FINALIZADO'
   and esp.created_at between '#{fecha_inicio}' and '#{fecha_fin}' -- rango de fechaan
 group by sp.nombre, sp.codigo"
      
      
      case demanda
      when 'mayor'
        sql += " order by cant_expedientes desc"
      when 'menor'
        sql += " order by cant_expedientes asc"
      end

      if cantidad.present?
        sql += " limit " + cantidad
      end
    
    end
    
    #en caso que se haya elegido el proceso
    if proceso.present?
      #en caso que el anho fin sea menor que el anho inicio, el anho fin sera del mismo valor que el del anho inicio
      sql = "select count(expedientes) cantidad, tt.tiempo from ( "
      if anho_inicio.present? && anho_fin.present?
        if(anho_fin <= anho_inicio)
          anho_fin = anho_inicio
          sql += "select te.expediente_id as expedientes, to_char(sp.created_at, 'MM/yyyy') as tiempo"
        else
          sql += "select te.expediente_id as expedientes, to_char(sp.created_at, 'yyyy') as tiempo "
        end
      end
    
      
      #concatenar para el inicio y el fin de los anhos
      fechainicio = anho_inicio + "-01-01"
      fechafin = anho_fin + "-01-01"
          
      #concatenar el sql
      sql += "
		  from expedientes sp, tareas_expedientes te, tareas t, actividades a, procedimientos p
		 where sp.id = te.expediente_id
		   and te.tarea_id = t.id
		   and t.actividad_id = a.id
		   and a.procedimiento_id = p.id
		   and sp.estado = 'FINALIZADO'
		   and sp.created_at between '#{fechainicio}' and '#{fechafin}' -- rango de fechaan
		   and p.serieproceso_id = #{proceso} -- proceso seleccionado
		 group by te.expediente_id, sp.created_at
	) tt
group by tt.tiempo 
order by tt.tiempo  asc;
      "
      
    end
    
    
    resultados = ActiveRecord::Base.connection.execute(sql).first
    return resultados

  end

end