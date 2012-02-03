class AccionesController < ApplicationController
  # GET /acciones
  # GET /acciones.json
  def index
    @acciones = Accion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @acciones }
    end
  end

  # GET /acciones/1
  # GET /acciones/1.json
  def show
    @accion = Accion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accion }
    end
  end

  # GET /acciones/new
  # GET /acciones/new.json
  def new
    @accion = Accion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accion }
    end
  end

  # GET /acciones/1/edit
  def edit
    @accion = Accion.find(params[:id])
  end

  # POST /acciones
  # POST /acciones.json
  def create
    @accion = Accion.new(params[:accion])

    respond_to do |format|
      if @accion.save
        format.html { redirect_to @accion, notice: 'Accion was successfully created.' }
        format.json { render json: @accion, status: :created, location: @accion }
      else
        format.html { render action: "new" }
        format.json { render json: @accion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /acciones/1
  # PUT /acciones/1.json
  def update
    @accion = Accion.find(params[:id])

    respond_to do |format|
      if @accion.update_attributes(params[:accion])
        format.html { redirect_to @accion, notice: 'Accion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acciones/1
  # DELETE /acciones/1.json
  def destroy
    @accion = Accion.find(params[:id])
    @accion.destroy

    respond_to do |format|
      format.html { redirect_to acciones_url }
      format.json { head :no_content }
    end
  end
end
