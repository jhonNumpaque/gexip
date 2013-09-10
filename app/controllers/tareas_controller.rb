# encoding: utf-8
class TareasController < ApplicationController
  # GET /tareas
  # GET /tareas.json
	#se encuentra en actividades_controller#listar_tareas
  def index
    @tareas = Tarea.where(:actividad_id => params[:actividad_id]).order("orden")

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # index.html.erb
      format.json { render json: @tareas }
      format.js
    end
  end

  # GET /tareas/1
  # GET /tareas/1.json
  def show
    @tarea_actual = Tarea.find(params[:id])
    @actividad_id = @tarea_actual.actividad_id
		
    respond_to do |format|
      format.html { render :layout => "popup_wf" } # show.html.erb
      format.json { render json: @tarea_actual }
    end
  end

  # GET /tareas/new
  # GET /tareas/new.json
	#se encuentra en actividades_controller#agregar_tarea
  def new
		@estructuras_opt = { :prompt => true }
	  @cargos_estructuras = []
    @tarea = Tarea.new
    @tarea.actividad_id = params[:actividad_id]
    @tarea.tarea_ant_id = @tarea.anterior.id if @tarea.anterior && !@tarea.anterior.es_logica?
    #@tarea.adjuntos_tareas_expedientes.build
    #@tarea.adjuntos_tareas_expedientes.first.cargos_estructuras_adjuntos.build
    @logicas_opciones = { :prompt => '-- Seleccione -- '}
    @rutas_logicas = view_context.options_for_select(Tarea::RutasLogicas.map{ |r| [r,r] })

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # new.html.erb
      format.json { render json: @tarea_actual }
      format.js
    end
  end

  # GET /tareas/1/edit
  def edit
    @tarea = Tarea.find(params[:id])
    @actividad_id = @tarea.actividad_id
    @cargos_estructuras = @tarea.cargo_estructura.estructura.cargos_estructuras
    @estructuras_opt = { :selected => @tarea.cargo_estructura.estructura_id }

    respond_to do |format|
			#      format.html { render :layout => "popup_wf" } # new.html.erb
			#      format.json { render json: @tarea_actual }
			format.js 
    end
  end

  # POST /tareas
  # POST /tareas.json
  def create
    @tarea = Tarea.new(params[:tarea])
    @actividad_id = @tarea.actividad_id

    respond_to do |format|
      if @tarea.save
        @tareas = Tarea.where(:actividad_id => @tarea.actividad_id).order("orden")
        #format.html { redirect_to tareas_path(:actividad_id => @tarea_actual.actividad_id), notice: 'Tarea Creada Correctamente.' }
        #format.json { render json: @tarea_actual, status: :created, location: @tarea_actual }
        format.js
      else
        format.html { render action: "new", :layout => "popup_wf" }
        #format.json { render json: @tarea_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tareas/1
  # PUT /tareas/1.json
  def update
    @tarea_actual = Tarea.find(params[:id])
    @actividad_id = @tarea_actual.actividad_id
		
    respond_to do |format|
      if @tarea_actual.update_attributes(params[:tarea])
        @tareas = Tarea.where(:actividad_id => @tarea_actual.actividad_id).order("orden")
        format.html { redirect_to tareas_path(:actividad_id => @tarea_actual.actividad_id), notice: 'Tarea Modificada Correctamente.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit", :layout => "popup_wf" }
        format.json { render json: @tarea_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tareas/1
  # DELETE /tareas/1.json
  def destroy
    @tarea_actual = Tarea.find(params[:id])
    @tareas = Tarea.where(:actividad_id => @tarea_actual.actividad_id).order("orden")
    @actividad_id = @tarea_actual.actividad_id
    @tarea_actual.destroy

    respond_to do |format|
      format.html { redirect_to tareas_url(:actividad_id => @tarea_actual.actividad_id), notice: 'Tarea Eliminada Correctamente.' }
      format.json { head :no_content }
      format.js
    end
  end
  
  def iniciar_tarea
    #eid = expediente id, tid = tarea id    
    if params[:eid].present? && params[:tid].present?
      Expediente.transaction do
        @expediente = Expediente.find(params[:eid])
        @tarea_actual = Tarea.find(params[:tid])
        tarea_anterior_id = @expediente.tarea_actual.id
      
        actividad = @tarea_actual.actividad
        procedimiento = actividad.procedimiento
      
        @tarea_expediente_actual = TareaExpediente.crear!(
          :procedimiento_id => procedimiento.id,
          :expediente_id => @expediente.id,
          :tarea_id => @tarea_actual.id,
          :usuario_inicio_id => current_usuario.id
        )         
        
        @expediente.update_attributes(
          :tarea_expediente_actual_id => @tarea_expediente_actual.id,
          :estado => Expediente.estado_procesando
        )
        @tarea_siguiente = @expediente.tarea_siguiente                
      
        qs = '(orden >= :orden and actividad_id = :aid) or (procedimiento_id = :pid and actividad_id > :aid)'
        qv = { :orden => @tarea_actual.orden, :aid => @tarea_actual.actividad_id, :pid => actividad.procedimiento_id }
        @vista_tareas_siguientes = VistaTarea.where(qs, qv).select('id, nombre, actividad_descripcion').limit(2)
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def iniciar_tarea_logica
    if params[:eid].present? && params[:tid].present? && params[:tc].present?
      tipo_confirm = params[:tc]
      
      TareaExpediente.transaction do
        @expediente = Expediente.find(params[:eid])
        tarea_logica = Tarea.find(params[:tid])
        actividad = tarea_logica.actividad
        procedimiento = actividad.procedimiento
        
        tarea_expediente_logica = TareaExpediente.crear!(
          :procedimiento_id => procedimiento.id,
          :expediente_id => @expediente.id,
          :tarea_id => tarea_logica.id,
          :usuario_inicio_id => current_usuario.id
        )                
        
        tarea_expediente_logica.finalizar!(current_usuario.id, 'Tarea Lógica')
        
        if tipo_confirm == 'tarea_si'
          @tarea_actual = tarea_logica.tarea_siguiente
          
          @tarea_expediente_actual = TareaExpediente.crear!(
            :procedimiento_id => procedimiento.id,
            :expediente_id => @expediente.id,
            :tarea_id => @tarea_actual.id,
            :usuario_inicio_id => current_usuario.id
          )

          @expediente.update_attributes(:tarea_expediente_actual => @tarea_expediente_actual,
            :tarea_anterior => tarea_logica)
          tarea_not = tarea_logica.tarea_alt_id
        else
          @tarea_actual = tarea_logica.tarea_alternativa

          @tarea_expediente_actual = TareaExpediente.crear!(
            :procedimiento_id => procedimiento.id,
            :expediente_id => @expediente.id,
            :tarea_id => @tarea_actual.id,
            :usuario_inicio_id => current_usuario.id
          )

          @expediente.update_attributes(:tarea_expediente_actual => @tarea_expediente_actual,
            :tarea_actual => @tarea_actual, :tarea_anterior => tarea_logica)
          tarea_not = tarea_logica.tarea_sgt_id
        end
        #@tarea_expediente_actual = @expediente.tarea_expediente_actual
        
        @tarea_siguiente = @expediente.tarea_siguiente
        qs = 'tarea_id not in (:tarea_logica_id, :tarea_not_id) and ((orden >= :orden and actividad_id = :aid) or (procedimiento_id = :pid and actividad_id > :aid))'
        qv = {  :tarea_logica_id => tarea_logica.id, :tarea_not_id => tarea_not, :orden => @tarea_actual.orden, 
                :aid => @tarea_actual.actividad_id, :pid => actividad.procedimiento_id }
        @vista_tareas = VistaTarea.where(qs, qv).select('id, nombre, actividad_descripcion').limit(2)        
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def iniciar_traslado
		Expediente.transaction do
			if params[:eid].present? && params[:tid].present?
				expediente = Expediente.find(params[:eid])
				tarea_logica = Tarea.find(params[:tid])
				actividad = tarea_logica.actividad
				procedimiento = actividad.procedimiento

				tarea_expediente_actual = TareaExpediente.crear!(
						:procedimiento_id => procedimiento.id,
						:expediente_id => expediente.id,
						:tarea_id => tarea_logica.id,
						:usuario_inicio_id => current_usuario.id
				)

				expediente.update_attributes(:tarea_expediente_actual => tarea_expediente_actual, :estado => 'TRANSITO')
				redirect_to expediente_path(params[:eid])
			else
				flash[:error] = "No se pudo trasladar el expediente, datos incompletos"
				redirect_to params[:eid].present? ? expediente_path(params[:eid]) : expedientes_path
			end
		end
  end

  def iniciar_archivado
	  Expediente.transaction do
		  if params[:eid].present? && params[:tid].present?
			  expediente = Expediente.find(params[:eid])
			  tarea_logica = Tarea.find(params[:tid])
			  actividad = tarea_logica.actividad
			  procedimiento = actividad.procedimiento

			  tarea_expediente_actual = TareaExpediente.crear!(
					  :procedimiento_id => procedimiento.id,
					  :expediente_id => expediente.id,
					  :tarea_id => tarea_logica.id,
					  :usuario_inicio_id => current_usuario.id
			  )

			  tarea_expediente_actual.finalizar!(current_usuario.id, 'Archivado')

			  expediente.update_attributes(:tarea_expediente_actual => tarea_expediente_actual, :estado => 'FINALIZADO')
			  redirect_to expediente_path(params[:eid])
		  else
			  flash[:error] = "No se pudo trasladar el expediente, datos incompletos"
			  redirect_to params[:eid].present? ? expediente_path(params[:eid]) : expedientes_path
		  end
	  end
  end
  
  def finalizar_tarea        
    #eid = expediente id, tid = tarea id   
    @vista_tareas = []
    if params[:eid].present? && params[:tid].present?
      Expediente.transaction do
        @expediente = Expediente.find(params[:eid])
        @tarea_expediente_actual = TareaExpediente.find(params[:tid])
        @tarea_siguiente = @expediente.tarea_siguiente
        @esta_tarea = @tarea_expediente_actual.tarea
        if @esta_tarea.es_fin?
					@expediente.finalizar!
        end
        
        if @tarea_siguiente
          actividad = @tarea_siguiente.actividad

          if @tarea_siguiente.es_logica?
            @tarea_actual = @expediente.tarea_actual
          else
            @tarea_actual = @expediente.tarea_actual
          end
        end
      
        @tarea_expediente_actual.finalizar!(current_usuario.id)
        #@expediente.update_attribute(:tarea_anterior_id, @tarea_expediente_actual.tarea_id)
        if @tarea_siguiente
          qs = '(orden >= :orden and actividad_id = :aid) or (procedimiento_id = :pid and actividad_id > :aid)'
          qv = { :orden => @tarea_siguiente.orden, :aid => @tarea_siguiente.actividad_id, :pid => actividad.procedimiento_id }
          @vista_tareas = VistaTarea.where(qs, qv).select('id, nombre, actividad_descripcion').limit(2)
        end
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def cancelar_tarea
    
    if (params[:eid].present? && params[:teid].present?)       
        @expediente = Expediente.find(params[:eid])
        @tarea_expediente_actual = TareaExpediente.find(params[:teid])                

        @tarea_expediente_actual.cancelar!(current_usuario.id)

        
        #tarea_expediente_anterior = TareaExpediente.where('id < ? and expediente_id = ?', @tarea_expediente_actual.id, @expediente.id).last
        tarea_expediente_anterior = TareaExpediente.find(@expediente.tarea_anterior_id)
        @tarea_expediente_actual = tarea_expediente_anterior
        @tarea_actual =  @tarea_expediente_actual.tarea
        
        @tarea_es_logica = @tarea_actual.es_logica?
        
        @expediente.update_attributes(:tarea_expediente_actual => tarea_expediente_anterior, :tarea_actual => @tarea_actual)
        @tarea_siguiente = @expediente.tarea_siguiente
        actividad = @tarea_siguiente.actividad
        
        qs = '(orden >= :orden and actividad_id = :aid) or (procedimiento_id = :pid and actividad_id > :aid)'
        qv = { :orden => @tarea_siguiente.orden, :aid => @tarea_siguiente.actividad_id, :pid => actividad.procedimiento_id }
        @vista_tareas_siguientes = VistaTarea.where(qs, qv).select('id, nombre, actividad_descripcion').limit(2)      
    end
    
    respond_to do |format|
      format.js
    end
  end

  def agregar_adjunto
    @adjunto = Adjunto.new(tarea_id: params[:tarea_id])
    
    respond_to do |format|
      format.js
    end
  end

  def respuestas_logicas
    tarea_logica = Tarea.find(params[:tarea_id])
    respuestas = []
    respuestas << { id: 'SI', valor: 'SI' } if tarea_logica.tarea_sgt_id.blank?
    respuestas << { id: 'NO', valor: 'NO' } if tarea_logica.tarea_alt_id.blank?

    respond_to do |format|
      format.json { render json: respuestas }
    end
  end

  def verificar_tarea_anterior
    #tarea_anterior = Tarea.find(params[:tarea_anterior_id]) if params[:tarea_anterior_id].present?
    tarea_logica = Tarea.find(params[:logica_id]) if params[:logica_id].present?

    if tarea_logica.dos_rutas_pendientes?
			@tarea_anterior = tarea_logica
			@respuestas_pendientes = ["SI","NO"]
    elsif tarea_logica.rutas_pendientes?
			puts "{{{{{{{{{{{{{{{{{{"
			@tareas_anteriores = { tarea_logica.logica_rutas_pendientes.first => tarea_logica }
			@respuestas_pendientes = tarea_logica.logica_rutas_pendientes
			ruta_disponible = tarea_logica.ruta_disponible?(tarea_logica.rutas_completadas.first)
			if ruta_disponible
				ruta_completada = tarea_logica.rutas_completadas.first
				@respuestas_pendientes << ruta_completada
				@tareas_anteriores[ruta_completada] = tarea_logica.ultima_en_rama(ruta_completada)
			end
			@tarea_anterior = @tareas_anteriores.values.first if @tareas_anteriores.keys.length == 1
    end

    puts "-----------------"
    puts "tarea_anterior: #{@tarea_anterior.inspect}"
    puts "respuestas_pendientes: #{@respuestas_pendientes.inspect}"
    puts "tareas_anteriores: #{@tareas_anteriores.inspect}"
    puts "-----------------"

    respond_to do |format|
      format.js
    end
  end
end

