class SubprocesosController < ApplicationController
  # GET /subprocesos
  # GET /subprocesos.json
  def index
    @subprocesos = Subproceso.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subprocesos }
    end
  end

  # GET /subprocesos/1
  # GET /subprocesos/1.json
  def show
    @subproceso = Subproceso.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subproceso }
    end
  end

  # GET /subprocesos/new
  # GET /subprocesos/new.json
  def new
    @subproceso = Subproceso.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subproceso }
    end
  end

  # GET /subprocesos/1/edit
  def edit
    @subproceso = Subproceso.find(params[:id])
  end

  # POST /subprocesos
  # POST /subprocesos.json
  def create
    @subproceso = Subproceso.new(params[:subproceso])

    respond_to do |format|
      if @subproceso.save
        format.html { redirect_to subprocesos_path, notice: 'Subproceso Creado Correctamente.' }
        format.json { render json: @subproceso, status: :created, location: @subproceso }
      else
        format.html { render action: "new" }
        format.json { render json: @subproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subprocesos/1
  # PUT /subprocesos/1.json
  def update
    @subproceso = Subproceso.find(params[:id])

    respond_to do |format|
      if @subproceso.update_attributes(params[:subproceso])
        format.html { redirect_to subproceso_path, notice: 'Subproceso Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subprocesos/1
  # DELETE /subprocesos/1.json
  def destroy
    @subproceso = Subproceso.find(params[:id])
    @subproceso.destroy

    respond_to do |format|
      format.html { redirect_to subprocesos_url, notice: 'Subproceso Modificado Correctamente.' }
      format.json { head :no_content }
    end
  end
end
