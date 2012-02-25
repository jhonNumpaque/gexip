class TareasController < ApplicationController
  # GET /tareas
  # GET /tareas.json
  def index
    @tareas = Tarea.where(:actividad_id => params[:actividad_id]).order("orden")

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # index.html.erb
      format.json { render json: @tareas }
    end
  end

  # GET /tareas/1
  # GET /tareas/1.json
  def show
    @tarea = Tarea.find(params[:id])

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # show.html.erb
      format.json { render json: @tarea }
    end
  end

  # GET /tareas/new
  # GET /tareas/new.json
  def new
    @tarea = Tarea.new

    respond_to do |format|
      format.html { render :layout => "popup_wf" } # new.html.erb
      format.json { render json: @tarea }
    end
  end

  # GET /tareas/1/edit
  def edit
    @tarea = Tarea.find(params[:id])
    
        respond_to do |format|
      format.html { render :layout => "popup_wf" } # new.html.erb
      format.json { render json: @tarea }
    end
  end

  # POST /tareas
  # POST /tareas.json
  def create
    @tarea = Tarea.new(params[:tarea])

    respond_to do |format|
      if @tarea.save
        format.html { redirect_to tareas_path(:actividad_id => @tarea.actividad_id), notice: 'Tarea Creada Correctamente.' }
        format.json { render json: @tarea, status: :created, location: @tarea }
      else
        format.html { render action: "new" }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tareas/1
  # PUT /tareas/1.json
  def update
    @tarea = Tarea.find(params[:id])

    respond_to do |format|
      if @tarea.update_attributes(params[:tarea])
        format.html { redirect_to tareas_path(:actividad_id => @tarea.actividad_id), notice: 'Tarea Modificada Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tareas/1
  # DELETE /tareas/1.json
  def destroy
    @tarea = Tarea.find(params[:id])
    @tarea.destroy

    respond_to do |format|
      format.html { redirect_to tareas_url(:actividad_id => @tarea.actividad_id), notice: 'Tarea Eliminada Correctamente.' }
      format.json { head :no_content }
    end
  end
end
