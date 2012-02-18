class MacroprocesosController < ApplicationController
  # GET /macroprocesos
  # GET /macroprocesos.json
  def index
    @macroprocesos = Macroproceso.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @macroprocesos }
    end
  end

  # GET /macroprocesos/1
  # GET /macroprocesos/1.json
  def show
    @macroproceso = Macroproceso.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @macroproceso }
    end
  end

  # GET /macroprocesos/new
  # GET /macroprocesos/new.json
  def new
    @macroproceso = Macroproceso.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @macroproceso }
    end
  end

  # GET /macroprocesos/1/edit
  def edit
    @macroproceso = Macroproceso.find(params[:id])
  end

  # POST /macroprocesos
  # POST /macroprocesos.json
  def create
    @macroproceso = Macroproceso.new(params[:macroproceso])

    respond_to do |format|
      if @macroproceso.save
        format.html { redirect_to macroprocesos_path, notice: 'MacroProceso Creado Correctamente.' }
        format.json { render json: @macroproceso, status: :created, location: @macroproceso }
      else
        format.html { render action: "new" }
        format.json { render json: @macroproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /macroprocesos/1
  # PUT /macroprocesos/1.json
  def update
    @macroproceso = Macroproceso.find(params[:id])
    respond_to do |format|
      if @macroproceso.update_attributes(params[:macroproceso])
        format.html { redirect_to macroprocesos_path, notice: 'MacroProceso Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @macroproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /macroprocesos/1
  # DELETE /macroprocesos/1.json
  def destroy
    @macroproceso = Macroproceso.find(params[:id])
    @macroproceso.destroy

    respond_to do |format|
      format.html { redirect_to macroprocesos_url, notice: 'MacroProceso Eliminado Correctamente.' }
      format.json { head :no_content }
    end
  end
end
