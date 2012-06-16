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
    @tarea_actual = Tarea.new

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # new.html.erb
      format.json { render json: @tarea_actual }
      format.js
    end
  end

  # GET /tareas/1/edit
  def edit
    @tarea_actual = Tarea.find(params[:id])
    @actividad_id = @tarea_actual.actividad_id
		respond_to do |format|
			#      format.html { render :layout => "popup_wf" } # new.html.erb
			#      format.json { render json: @tarea_actual }
			format.js 
    end
  end

  # POST /tareas
  # POST /tareas.json
  def create
    tarea = Tarea.new(params[:tarea])
    @actividad_id = tarea.actividad_id
	
    respond_to do |format|
      if tarea.save
        @tareas = Tarea.where(:actividad_id => tarea.actividad_id).order("orden")
        format.html { redirect_to tareas_path(:actividad_id => @tarea_actual.actividad_id), notice: 'Tarea Creada Correctamente.' }
        format.json { render json: @tarea_actual, status: :created, location: @tarea_actual }
        format.js
      else
        format.html { render action: "new", :layout => "popup_wf" }
        format.json { render json: @tarea_actual.errors, status: :unprocessable_entity }
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
      
        actividad = @tarea_actual.actividad
        procedimiento = actividad.procedimiento
      
        @tarea_expediente_actual = TareaExpediente.new
        @tarea_expediente_actual.procedimiento = procedimiento
        @tarea_expediente_actual.expediente = @expediente
        @tarea_expediente_actual.tarea = @tarea_actual
        @tarea_expediente_actual.usuario_inicio_id = current_usuario.id
        @tarea_expediente_actual.fecha_inicio = Time.now
        @tarea_expediente_actual.estado = TareaExpediente.estado_inicial
        @tarea_expediente_actual.save
        
        @expediente.update_attributes(:tarea_expediente_actual => @tarea_expediente_actual, :tarea_actual => @tarea_actual)
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
  
  def finalizar_tarea        
    #eid = expediente id, tid = tarea id    
    if params[:eid].present? && params[:tid].present?
      Expediente.transaction do
        @expediente = Expediente.find(params[:eid])
        @tarea_expediente_actual = TareaExpediente.find(params[:tid])
        @tarea_siguiente = @expediente.tarea_siguiente
        actividad = @tarea_siguiente.actividad
        @tarea_actual = @expediente.tarea_actual      
      
        @tarea_expediente_actual.fecha_fin = Time.now      
        @tarea_expediente_actual.usuario_fin_id = current_usuario.id
        @tarea_expediente_actual.finalizar!
        @tarea_expediente_actual.save
        
        qs = '(orden >= :orden and actividad_id = :aid) or (procedimiento_id = :pid and actividad_id > :aid)'
        qv = { :orden => @tarea_siguiente.orden, :aid => @tarea_siguiente.actividad_id, :pid => actividad.procedimiento_id }
        @vista_tareas_siguientes = VistaTarea.where(qs, qv).select('id, nombre, actividad_descripcion').limit(2)
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
        
        @tarea_expediente_actual.fecha_fin = Time.now
        @tarea_expediente_actual.usuario_fin_id = current_usuario.id
        @tarea_expediente_actual.cancelar!
        @tarea_expediente_actual.save
        
        tarea_expediente_anterior = TareaExpediente.where('id < ? and expediente_id = ?', @tarea_expediente_actual.id, @expediente.id).last
        @tarea_expediente_actual = tarea_expediente_anterior
        @tarea_actual =  @tarea_expediente_actual.tarea
        
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
end

