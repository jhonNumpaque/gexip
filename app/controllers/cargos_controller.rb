class CargosController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /cargos
  # GET /cargos.json
  def index
    if params[:ente_id].present?
      ente = Ente.find(params[:ente_id])
      @cargos = ente.cargos
    else
      @cargos = Cargo
      @cargos = @cargos.where("nombre like ?", "%#{params[:nombre]}%") if params[:nombre].present?
      @cargos = @cargos.page(params[:page]).per(10)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cargos }
    end
  end

  # GET /cargos/1
  # GET /cargos/1.json
  def show
    @cargo = Cargo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cargo }
    end
  end

  # GET /cargos/new
  # GET /cargos/new.json
  def new
    @cargo = Cargo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cargo }
    end
  end

  # GET /cargos/1/edit
  def edit
    @cargo = Cargo.find(params[:id])
  end

  # POST /cargos
  # POST /cargos.json
  def create
    @cargo = Cargo.new(params[:cargo])

    respond_to do |format|
      if @cargo.save
        @cargos = Cargo.all
        format.html { redirect_to cargos_path, notice: 'Cargo creado' }
        format.json { render json: @cargo, status: :created, location: @cargo }
        format.js
      else
        format.html { render action: "new" }
        format.js
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cargos/1
  # PUT /cargos/1.json
  def update
    @cargo = Cargo.find(params[:id])

    respond_to do |format|
      if @cargo.update_attributes(params[:cargo])
        format.html { redirect_to cargos_path, notice: 'Cargo actualizado' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cargos/1
  # DELETE /cargos/1.json
  def destroy
    @cargo = Cargo.find(params[:id])
    
    begin
      @cargo.destroy
      flash[:notice] = "Cargo Eliminado Correctamente."
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar el Cargo!.'
    end
    respond_to do |format|
      format.html { redirect_to cargos_url}
      format.json { head :no_content }
    end
  end

  def agregar_cargo
    @cargo = Cargo.new

    respond_to do |format|
      format.js
    end
  end
end
