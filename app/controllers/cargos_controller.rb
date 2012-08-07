class CargosController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /cargos
  # GET /cargos.json
  def index
    @cargos = Cargo
    
    @cargos = @cargos.where("nombre like ?", "%#{params[:nombre]}%") if params[:nombre].present?
    
    @cargos = @cargos.page(params[:page]).per(10)
    
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
        format.html { redirect_to cargos_path, notice: 'Cargo creado' }
        format.json { render json: @cargo, status: :created, location: @cargo }
      else
        format.html { render action: "new" }
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
end
