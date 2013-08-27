class PersonasFisicasController < ApplicationController
  before_filter :authenticate_usuario!
  # GET /personas_fisicas
  # GET /personas_fisicas.json
  def index
    @personas_fisicas = PersonaFisica

    if params[:valor].present?
      case params[:tipo_busqueda]
      when "NOMBRE"
        @personas_fisicas = @personas_fisicas.where(" nombre LIKE ? ", "%"+params[:valor]+"%")
      when "APELLIDO"
        @personas_fisicas = @personas_fisicas.where(" apellido LIKE ? ", "%"+params[:valor]+"%")
      when "DOCUMENTO"
        @personas_fisicas = @personas_fisicas.where(" documento LIKE ? ", "%"+params[:valor]+"%")
      else
        @personas_fisicas = @personas_fisicas.where(" nombre LIKE ? OR apellido LIKE ? OR documento LIKE ? ", "%"+params[:valor]+"%","%"+params[:valor]+"%","%"+params[:valor]+"%")
      end
      @personas_fisicas = @personas_fisicas.page(params[:page]).order('id').per(50)
    elsif params[:filtro_ciudad].present?
      @personas_fisicas = @personas_fisicas.where(" territorio_id = ? ", params[:filtro_ciudad])
      @personas_fisicas = @personas_fisicas.page(params[:page]).order('id').per(50)
    else
      #@usuarios = Usuario.all
      @personas_fisicas = PersonaFisica.page(params[:page]).order('id').per(50)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @personas_fisicas }
    end
  end

  # GET /personas_fisicas/1
  # GET /personas_fisicas/1.json
  def show
    @persona_fisica = PersonaFisica.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_fisica }
    end
  end

  # GET /personas_fisicas/new
  # GET /personas_fisicas/new.json
  def new
    @persona_fisica = PersonaFisica.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_fisica }
    end
  end

  # GET /personas_fisicas/1/edit
  def edit
    @persona_fisica = PersonaFisica.find(params[:id])
    #
    ##para mostrar el cargo y el ente que se encuentran seleccionados
    #cargo_ente = CargoEnte.find(@persona_fisica.cargo_ente_id)
    #@ente = Ente.find(cargo_ente.ente_id)
    #@cargo = Ente.find(cargo_ente.cargo_id)
    ##buscar todos los cargos del ente para mostrar en el select
    #cargos_ente = CargoEnte.where(:ente_id => @ente.id).all
    #@cargos = Cargo.find(cargos_ente.map{|x| x.cargo_id})
  end

  # POST /personas_fisicas
  # POST /personas_fisicas.json
  def create
    @persona_fisica = PersonaFisica.new(params[:persona_fisica])

    if params[:cargo_id].present? && params[:ente_id].present?
      cargo_ente = CargoEnte.where("cargo_id = ? and ente_id = ?", "#{params[:cargo_id]}", "#{params[:ente_id]}").first
      @persona_fisica.cargo_ente_id = cargo_ente.id
    end

    respond_to do |format|
      if @persona_fisica.save
        format.html { redirect_to personas_fisicas_path, notice: 'Persona Fisica Creada Correctamente.' }
        format.json { render json: @persona_fisica, status: :created, location: @persona_fisica }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_fisica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /personas_fisicas/1
  # PUT /personas_fisicas/1.json
  def update
    @persona_fisica = PersonaFisica.find(params[:id])

    respond_to do |format|
      if @persona_fisica.update_attributes(params[:persona_fisica])
        format.html { redirect_to personas_fisicas_path, notice: 'Persona Fisica Modificada Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_fisica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personas_fisicas/1
  # DELETE /personas_fisicas/1.json
  def destroy
    @persona_fisica = PersonaFisica.find(params[:id])

    begin
      @persona_fisica.destroy
      flash[:notice] = "Persona Fisica Eliminada Correctamente."
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar la Persona Fisica!.'  
    end

    respond_to do |format|
      format.html { redirect_to personas_fisicas_url }
      format.json { head :no_content }
    end
  end
end
