class UnidadesTiemposController < ApplicationController
  # GET /unidades_tiempos
  # GET /unidades_tiempos.json
  def index
    @unidades_tiempos = UnidadTiempo.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @unidades_tiempos }
    end
  end

  # GET /unidades_tiempos/1
  # GET /unidades_tiempos/1.json
  def show
    @unidad_tiempo = UnidadTiempo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unidad_tiempo }
    end
  end

  # GET /unidades_tiempos/new
  # GET /unidades_tiempos/new.json
  def new
    @unidad_tiempo = UnidadTiempo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unidad_tiempo }
    end
  end

  # GET /unidades_tiempos/1/edit
  def edit
    @unidad_tiempo = UnidadTiempo.find(params[:id])
  end

  # POST /unidades_tiempos
  # POST /unidades_tiempos.json
  def create
    @unidad_tiempo = UnidadTiempo.new(params[:unidad_tiempo])

    respond_to do |format|
      if @unidad_tiempo.save
        format.html { redirect_to unidades_tiempos_path, notice: 'Unidad de tiempo creada.' }
        format.json { render json: @unidad_tiempo, status: :created, location: @unidad_tiempo }
      else
        format.html { render action: "new" }
        format.json { render json: @unidad_tiempo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /unidades_tiempos/1
  # PUT /unidades_tiempos/1.json
  def update
    @unidad_tiempo = UnidadTiempo.find(params[:id])

    respond_to do |format|
      if @unidad_tiempo.update_attributes(params[:unidad_tiempo])
        format.html { redirect_to unidades_tiempos_path, notice: 'Unidad de tiempo actualizada.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unidad_tiempo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unidades_tiempos/1
  # DELETE /unidades_tiempos/1.json
  def destroy
    @unidad_tiempo = UnidadTiempo.find(params[:id])
    @unidad_tiempo.destroy

    respond_to do |format|
      format.html { redirect_to unidades_tiempos_url }
      format.json { head :no_content }
    end
  end
end
