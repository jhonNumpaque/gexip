class EstructurasController < ApplicationController
  before_filter :authenticate_usuario!
	  # GET /estructuras
  # GET /estructuras.json
  def index
    @estructuras = Estructura

    if params[:valor].present?
      case params[:tipo_busqueda]
      when "NOMBRE"
        @estructuras = @estructuras.where(" nombre LIKE ? ", "%"+params[:valor]+"%")
      when "DOCUMENTO"
        @estructuras = @estructuras.where(" documento LIKE ? ", "%"+params[:valor]+"%")
      else
        @estructuras = @estructuras.where(" nombre LIKE ? OR documento LIKE ? ", "%"+params[:valor]+"%","%"+params[:valor]+"%")
      end
      @estructuras = @estructuras.page(params[:page]).order('id').per(50)
    elsif params[:filtro_ciudad].present?
      @estructuras = @estructuras.where(" territorio_id = ? ", params[:filtro_ciudad])
      @estructuras = @estructuras.page(params[:page]).order('id').per(50)
    else
      #@usuarios = Usuario.all
      @estructuras = Estructura.page(params[:page]).order('id').per(50)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estructuras }
    end
  end

  # GET /estructuras/1
  # GET /estructuras/1.json
  def show
    @estructura = Estructura.find(params[:id])
    @cargos_actuales = @estructura.cargos

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @estructura }
    end
  end

  # GET /estructuras/new
  # GET /estructuras/new.json
  def new
    @estructura = Estructura.new

    @cargos = Cargo.all
    @cargos_actuales = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @estructura }
    end
  end

  # GET /estructuras/1/edit
  def edit
    @estructura = Estructura.find(params[:id])
    @cargos = Cargo.all
    @cargos_actuales = @estructura.cargos
  end

  # POST /estructuras
  # POST /estructuras.json
  def create
    @estructura = Estructura.new(params[:estructura])

    cargos = Cargo.where(:id => params[:cargos])
    @estructura.cargos = cargos

    respond_to do |format|
      if @estructura.save
        format.html { redirect_to estructuras_path, notice: 'Estructura Creada Correctamente.' }
        format.json { render json: @estructura, status: :created, location: @estructura }
      else
        @cargos = Cargo.all
        @cargos_actuales = cargos

        format.html { render action: "new" }
        format.json { render json: @estructura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /estructuras/1
  # PUT /estructuras/1.json
  def update
    @estructura = Estructura.find(params[:id])

    respond_to do |format|
      if @estructura.update_attributes(params[:estructura])
        format.html { redirect_to estructuras_path, notice: 'Estructura Modificada Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @estructura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estructuras/1
  # DELETE /estructuras/1.json
  def destroy
    @estructura = Estructura.find(params[:id])

    begin
      @estructura.destroy
      flash[:notice] = "Estructura Eliminada Correctamente."
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar la Estructura!.'  
    end


    respond_to do |format|
      format.html { redirect_to estructuras_url }
      format.json { head :no_content }
    end
  end
end
