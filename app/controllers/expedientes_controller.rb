class ExpedientesController < ApplicationController
  before_filter :authenticate_usuario!  
  # GET /expedientes
  # GET /expedientes.json
  def index

    #select b.expediente_id from vw_bandeja_usuarios b where b.usuario_id = 212;
  #Expediente.where(:id => exp.map(&:expediente_id))
    #vw_bandeja_usuario_nuevos 
    #current_usuario.id

    # expedientes nuevos
    exp2_filtro = Expediente.find_by_sql("select b.expediente_id from vw_bandeja_usuario_nuevos b where b.usuario_id = #{current_usuario.id}")
    exp2_arra = exp2_filtro.map(&:expediente_id)
    
    @expedientes_nuevos = Expediente.where(:id => exp2_arra)

    # expedientes en proceso
    #exp1_filtro = Expediente.find_by_sql("select b.expediente_id from vw_bandeja_usuario_procesos b where b.usuario_id = #{current_usuario.id}")
    exp1_filtro = Expediente.find_by_sql("select b.expediente_id from vista_expedientes_procesando b where b.cargo_estructura_id = #{current_usuario.funcionario.cargo_estructura_id}")
    exp1_arra = exp1_filtro.map(&:expediente_id)

    exp3_filtro = Expediente.find_by_sql("select b.expediente_id from vista_expedientes_procesando2 b where b.cargo_estructura_id = #{current_usuario.funcionario.cargo_estructura_id}")
    exp3_arra = exp3_filtro.map(&:expediente_id) if exp3_filtro

    exp1_arra ||= []
    exp1_arra.concat(exp3_arra) if exp3_arra.present?

    # transito (bandeja de entrada)
    exp2_filtro = Expediente.find_by_sql("select b.expediente_id from vista_expedientes_transito b where b.cargo_estructura_destino_id = #{current_usuario.funcionario.cargo_estructura_id}")
    exp2_arra = exp2_filtro.map(&:expediente_id)

    exp4_filtro = Expediente.find_by_sql("select b.expediente_id from vista_expedientes_transito b where b.cargo_estructura_origen_id = #{current_usuario.funcionario.cargo_estructura_id}")
    exp4_arra = exp4_filtro.map(&:expediente_id)

    puts "----------------------------"
    puts exp4_arra.inspect

    @expedientes_procesos = Expediente.where(:id => exp1_arra)

    @expedientes_entradas = Expediente.where(:id => exp2_arra)
    @expedientes_salidas = Expediente.where(:id => exp4_arra)




    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expedientes }
    end
  end

  def recibir
		expediente = Expediente.find(params[:id])

		expediente.recibir!(current_usuario)
  end

  # GET /expedientes/1
  # GET /expedientes/1.json
  def show
    @expediente = Expediente.find(params[:id])
    
    @tarea_expediente_actual = @expediente.tarea_expediente_actual
    @tarea_actual = @expediente.tarea_actual
    @tarea_siguiente = @expediente.tarea_siguiente

    if @tarea_siguiente
      tarea_anterior = @expediente.tarea_anterior
      actividad = @tarea_actual.actividad
      orden = @tarea_expediente_actual.finalizado? ? @tarea_siguiente.orden : @tarea_actual.orden

      query_string = '('    
      query_values = {}
      if @tarea_expediente_actual.finalizado? || @tarea_expediente_actual.tarea.es_traslado?
        query_string = '(id <> :id and '
        query_values[:id] = @tarea_actual.id
        actividad = @tarea_siguiente.actividad
      end

      if tarea_anterior
        if tarea_anterior.es_logica?
          query_string += 'id not in (:tarea_logica, :tarea_not) and '
          query_values[:tarea_logica] = tarea_anterior.id
          query_values[:tarea_not] = @tarea_actual.id == tarea_anterior.tarea_sgt_id ? tarea_anterior.tarea_alt_id : tarea_anterior.tarea_sgt_id
        end
      end

      #if @tarea_actual.es_proceso_si?
      #  query_string += 'id <> :id_not and '
      #  query_values[:id_not] = tarea_anterior.tarea_alt_id
      #elsif @tarea_actual.es_proceso_no?
      #  query_string += 'id <> :id_not and '
      #  query_values[:id_not] = tarea_anterior.tarea_sig_id
      #end

      query_values.merge!({ :orden => orden, :actividad_id => actividad.id, :procedimiento_id => actividad.procedimiento_id, :actividad_orden => actividad.orden })    
      query_string += 'orden >= :orden and actividad_id = :actividad_id) or (procedimiento_id = :procedimiento_id and actividad_orden > :actividad_orden)'        

      # .del_cargo(current_usuario.ente.cargo_id)

      @vista_tareas = VistaTarea.del_cargo_estructura(current_usuario.funcionario.cargo_estructura_id).order('actividad_id,orden').limit(2).where(query_string,query_values).all
      #busca las tareas realizadas
      @seguimiento_tareas = VistaTarea.order('actividad_id,orden').where(:procedimiento_id => actividad.procedimiento_id)
      #buscar todas las tareas
      @vista_expediente_proceso = VistaExpedienteProceso.select('DISTINCT tarea_id, tarea_expediente_fecha_fin, tarea_expediente_fecha_inicio, tarea_expediente_usuario_inicio, tarea_expediente_usuario_fin').where(:expediente_id => @expediente).group('tarea_id, tarea_expediente_fecha_fin, tarea_expediente_fecha_inicio, tarea_expediente_usuario_inicio, tarea_expediente_usuario_fin')

    end
    @seguimiento_tareas = VistaTarea.order('actividad_id,orden').where(:procedimiento_id => @tarea_actual.actividad.procedimiento_id).all
    @vista_expediente_proceso = VistaExpedienteProceso.select('DISTINCT tarea_id, tarea_expediente_fecha_fin, tarea_expediente_fecha_inicio, tarea_expediente_usuario_inicio, tarea_expediente_usuario_fin').where(:expediente_id => @expediente).group('tarea_id, tarea_expediente_fecha_fin, tarea_expediente_fecha_inicio, tarea_expediente_usuario_inicio, tarea_expediente_usuario_fin').all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expediente }
    end
  end


  #def show
  #  @expediente = Expediente.find(params[:id])
  #
  #  @tarea_expediente_actual = @expediente.tarea_expediente_actual
  #  @tarea_actual = @expediente.tarea_actual
  #  @tarea_siguiente = @expediente.tarea_siguiente
  #
  #  if @tarea_siguiente
  #    tarea_anterior = @expediente.tarea_anterior
  #    actividad = @tarea_actual.actividad
  #    orden = @tarea_expediente_actual.finalizado? ? @tarea_siguiente.orden : @tarea_actual.orden
  #
  #    query_string = '('
  #    query_values = {}
  #    if @tarea_expediente_actual.finalizado?
  #      query_string = '(id <> :id and '
  #      query_values[:id] = @tarea_actual.id
  #      actividad = @tarea_siguiente.actividad
  #    end
  #
  #    if tarea_anterior
  #      if tarea_anterior.es_logica?
  #        query_string += 'id not in (:tarea_logica, :tarea_not) and '
  #        query_values[:tarea_logica] = tarea_anterior.id
  #        query_values[:tarea_not] = @tarea_actual.id == tarea_anterior.tarea_sgt_id ? tarea_anterior.tarea_alt_id : tarea_anterior.tarea_sgt_id
  #      end
  #    end
  #
  #    if @tarea_actual.es_proceso_si?
  #      query_string += 'id <> :id_not and '
  #      query_values[:id_not] = tarea_anterior.tarea_alt_id
  #    elsif @tarea_actual.es_proceso_no?
  #      query_string += 'id <> :id_not and '
  #      query_values[:id_not] = tarea_anterior.tarea_sig_id
  #    end
  #
  #    query_values.merge!({ :orden => orden, :actividad_id => actividad.id, :procedimiento_id => actividad.procedimiento_id, :actividad_orden => actividad.orden })
  #    query_string += 'orden >= :orden and actividad_id = :actividad_id) or (procedimiento_id = :procedimiento_id and actividad_orden > :actividad_orden)'
  #
  #    # .del_cargo(current_usuario.ente.cargo_id)
  #    @vista_tareas = VistaTarea.order('actividad_id,orden').limit(2).where(query_string,query_values)
  #  end
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @expediente }
  #  end
  #end

  # GET /expedientes/new
  # GET /expedientes/new.json
  def new
    @expediente = Expediente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expediente }
    end
  end

  # GET /expedientes/1/edit
  def edit
    @expediente = Expediente.find(params[:id])
  end

  # POST /expedientes
  # POST /expedientes.json
  def create
    @expediente = Expediente.new(params[:expediente])    
    @expediente.usuario_id = current_usuario.id

    respond_to do |format|
      if @expediente.save
        format.html { redirect_to @expediente, notice: 'Expediente Creado Correctamete.' }
        format.json { render json: @expediente, status: :created, location: @expediente }
      else
        format.html { render action: "new" }
        format.json { render json: @expediente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expedientes/1
  # PUT /expedientes/1.json
  def update
    @expediente = Expediente.find(params[:id])

    respond_to do |format|
      if @expediente.update_attributes(params[:expediente])
        format.html { redirect_to @expediente, notice: 'Expediente was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expediente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expedientes/1
  # DELETE /expedientes/1.json
  def destroy
    @expediente = Expediente.find(params[:id])
    @expediente.destroy

    respond_to do |format|
      format.html { redirect_to expedientes_url }
      format.json { head :no_content }
    end
  end
end
