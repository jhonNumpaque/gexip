class ProcesosController < ApplicationController
  # GET /procesos
  # GET /procesos.json
  def index
    @procesos = Proceso
    @procesos = @procesos.where(:serieproceso_id => params[:macroproceso_id]) if (params[:macroproceso_id].present?)
    @procesos = @procesos.all
    
    @macroprocesos = Macroproceso.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @procesos }
    end
  end

  # GET /procesos/1
  # GET /procesos/1.json
  def show
    @proceso = Proceso.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proceso }
    end
  end

  # GET /procesos/new
  # GET /procesos/new.json
  def new
    @proceso = Proceso.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proceso }
    end
  end

  # GET /procesos/1/edit
  def edit
    @proceso = Proceso.find(params[:id])
  end

  # POST /procesos
  # POST /procesos.json
  def create
    @proceso = Proceso.new(params[:proceso])

    respond_to do |format|
      if @proceso.save
        format.html { redirect_to procesos_path, notice: 'Proceso Creado Correctamente.' }
        format.json { render json: @proceso, status: :created, location: @proceso }
      else
        format.html { render action: "new" }
        format.json { render json: @proceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /procesos/1
  # PUT /procesos/1.json
  def update
    @proceso = Proceso.find(params[:id])

    respond_to do |format|
      if @proceso.update_attributes(params[:proceso])
        format.html { redirect_to procesos_path, notice: 'Proceso Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procesos/1
  # DELETE /procesos/1.json
  def destroy
    @proceso = Proceso.find(params[:id])
    @proceso.destroy

    respond_to do |format|
      format.html { redirect_to procesos_url, notice: 'Proceso Eliminado Correctamente.' }
      format.json { head :no_content }
    end
  end
  
  # GET /procesos/imprimir/reporte_formato_38?
  def reporte_formato_38
    #    @procesos = Proceso
    #    @macroproceso = MacroProceso
    #    if (params[:macroproceso_id].present?)
    @procesos = Proceso.where(:serieproceso_id => params[:macroproceso_id])
    @macroproceso = Macroproceso.find(params[:macroproceso_id])
    #    end
    
    respond_to do |format|
      format.html { render :layout => "popup_wf" } # show.html.erb
      #format.json { render json: @macroproceso }
    end
  end
  
end
