class FuncionariosController < ApplicationController
  before_filter :authenticate_usuario!
	 # GET /funcionarios
  # GET /funcionarios.json
  def index
  	@funcionarios = Funcionario

  	if params[:valor].present?
  		case params[:tipo_busqueda]
  		when "NOMBRE"
  			@funcionarios = @funcionarios.where(" nombres LIKE ? ", "%"+params[:valor]+"%")
  		when "APELLIDO"
  			@funcionarios = @funcionarios.where(" apellidos LIKE ? ", "%"+params[:valor]+"%")
  		when "DOCUMENTO"
  			@funcionarios = @funcionarios.where(" documento LIKE ? ", "%"+params[:valor]+"%")
  		else
  			@funcionarios = @funcionarios.where(" nombres LIKE ? OR apellidos LIKE ? OR documento LIKE ? ", "%"+params[:valor]+"%","%"+params[:valor]+"%","%"+params[:valor]+"%")
  		end
  		@funcionarios = @funcionarios.page(params[:page]).order('id').per(50)
  	elsif params[:filtro_ciudad].present?
  		@funcionarios = @funcionarios.where(" territorio_id = ? ", params[:filtro_ciudad])
  		@funcionarios = @funcionarios.page(params[:page]).order('id').per(50)
  	else
      #@usuarios = Usuario.all
      @funcionarios = Funcionario.page(params[:page]).order('id').per(50)
  end

  respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @funcionarios }
  end
end

  # GET /funcionarios/1
  # GET /funcionarios/1.json
  def show
  	@funcionario = Funcionario.find(params[:id])

  	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @funcionario }
      format.js 
  end
end

  # GET /funcionarios/new
  # GET /funcionarios/new.json
  def new
  	@funcionario = Funcionario.new
	  @estructuras_opts = { :prompt => true }
	  @cargos_estructuras = []

  	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @funcionario }
  end
end

  # GET /funcionarios/1/edit
  def edit
  	@funcionario = Funcionario.find(params[:id])
    #para mostrar el cargo y el ente que se encuentran seleccionados
    #cargo_estructura = CargoEstructura.find(@funcionario.cargo_estructura_id)
    #@estructura = Estructura.find(cargo_estructura.estructura_id)
    #@cargo = Estructura.find(cargo_estructura.cargo_id)
    #buscar todos los cargos del ente para mostrar en el select
    #cargos_estructura = CargoEstructura.where(:estructura_id => @estructura.id).all
    #@cargos = Cargo.find(cargos_estructura.map{|x| x.cargo_id})

	  @cargos_estructuras = @funcionario.cargo_estructura.estructura.cargos_estructuras
	  @estructuras_opts = { :selected => @funcionario.cargo_estructura.estructura_id }
end

  # POST /funcionarios
  # POST /funcionarios.json
  def create
  	@funcionario = Funcionario.new(params[:funcionario])
	  @cargos_estructuras = @funcionario.cargo_estructura ? @funcionario.cargo_estructura.estructura.cargos_estructuras : []
	  @estructuras_opts = @cargos_estructuras.present? ? { :selected => @funcionario.cargo_estructura.estructura_id } : { :prompt => true }

    if params[:cargo_id].present? && params[:estructura_id].present?
      cargo_estructura = CargoEstructura.where("cargo_id = ? and estructura_id = ?", "#{params[:cargo_id]}", "#{params[:estructura_id]}").first
      @funcionario.cargo_estructura_id = cargo_estructura.id
    end

  #	if params[:cargo_id].present? && params[:ente_id].present?
  #		cargo_ente = CargoEnte.where("cargo_id = ? and ente_id = ?", "#{params[:cargo_id]}", "#{params[:ente_id]}").first
  #		@funcionario.cargo_ente_id = cargo_ente.id
  #	end

  	respond_to do |format|
  		if @funcionario.save
  			format.html { redirect_to funcionarios_path, notice: 'Funcionario Creado Correctamente.' }
  			format.json { render json: @funcionario, status: :created, location: @funcionario }
  		else
  			format.html { render action: "new" }
  			format.json { render json: @funcionario.errors, status: :unprocessable_entity }
  		end
  	end
  end

  # PUT /funcionarios/1
  # PUT /funcionarios/1.json
  def update
  	@funcionario = Funcionario.find(params[:id])

  	respond_to do |format|
  		if @funcionario.update_attributes(params[:funcionario])
			  @cargos_estructuras = @funcionario.cargo_estructura ? @funcionario.cargo_estructura.estructura.cargos_estructuras : []
			  @estructuras_opts = @cargos_estructuras.present? ? { :selected => @funcionario.cargo_estructura.estructura_id } : { :prompt => true }

  			format.html { redirect_to funcionarios_path, notice: 'Funcionario Modificado Correctamente.' }
  			format.json { head :no_content }
  		else
  			format.html { render action: "edit" }
  			format.json { render json: @funcionario.errors, status: :unprocessable_entity }
  		end
  	end
  end

  # DELETE /funcionarios/1
  # DELETE /funcionarios/1.json
  def destroy
  	@funcionario = Funcionario.find(params[:id])

  	begin
  		@funcionario.destroy
  		flash[:notice] = "Funcionario Eliminado Correctamente."
  	rescue ActiveRecord::DeleteRestrictionError
  		flash[:alert] = 'No se puede eliminar al Funcionario!.'  
  	end

  	respond_to do |format|
  		format.html { redirect_to funcionarios_url }
  		format.json { head :no_content }
  	end
  end
end
