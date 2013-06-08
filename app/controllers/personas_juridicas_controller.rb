class PersonasJuridicasController < ApplicationController
  before_filter :authenticate_usuario!
  # GET /personas_juridicas
  # GET /personas_juridicas.json
  def index
    @personas_juridicas = PersonaJuridica
    
    if params[:valor].present?
      case params[:tipo]
      when 'DOCUMENTO'
        @personas_juridicas = @personas_juridicas.where(" documento = ?", params[:valor])
      when 'NOMBRE'
        @personas_juridicas = @personas_juridicas.where(" nombre like ? ", "%#{params[:valor]}%")
      when 'DIRECCION'
        @personas_juridicas = @personas_juridicas.where(" direccion like ?", "%#{params[:valor]}%")
      when 'TELEFONO'
        @personas_juridicas = @personas_juridicas.where(" telefono = ?", params[:valor])
      else
        @personas_juridicas = @personas_juridicas.where(" documento = ? or nombre like ? or apellido like ? or direccion like ? or telefono = ?", params[:valor], "%#{params[:valor]}%", "%#{params[:valor]}%", "%#{params[:valor]}%", params[:valor])
      end
    end
    
    @personas_juridicas = @personas_juridicas.where(" territorio_id = ?", params[:filtro_ciudad]) if params[:filtro_ciudad].present?
    
    @personas_juridicas = @personas_juridicas.page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @personas_juridicas }
    end
  end

  # GET /personas_juridicas/1
  # GET /personas_juridicas/1.json
  def show
    @persona_juridica = PersonaJuridica.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_juridica }
    end
  end

  # GET /personas_juridicas/new
  # GET /personas_juridicas/new.json
  def new
    @persona_juridica = PersonaJuridica.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_juridica }
    end
  end

  # GET /personas_juridicas/1/edit
  def edit
    @persona_juridica = PersonaJuridica.find(params[:id])
  end

  # POST /personas_juridicas
  # POST /personas_juridicas.json
  def create
    @persona_juridica = PersonaJuridica.new(params[:persona_juridica])

    respond_to do |format|
      if @persona_juridica.save
        format.html { redirect_to personas_juridicas_path, notice: 'Persona Juridica Creada Correctamente!' }
        format.json { render json: @persona_juridica, status: :created, location: @persona_juridica }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_juridica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /personas_juridicas/1
  # PUT /personas_juridicas/1.json
  def update
    @persona_juridica = PersonaJuridica.find(params[:id])

    respond_to do |format|
      if @persona_juridica.update_attributes(params[:persona_juridica])
        format.html { redirect_to personas_juridicas_path, notice: 'Persona Juridica Modificada Correctamente!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_juridica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personas_juridicas/1
  # DELETE /personas_juridicas/1.json
  def destroy
    @persona_juridica = PersonaJuridica.find(params[:id])
    begin
      @persona_juridica.destroy
      flash[:notice] = "Persona Juridica Eliminada Correctamente!"
    rescue
      flash[:alert] = "Persona Juridica No puede ser Eliminada!"
    end

    respond_to do |format|
      format.html { redirect_to personas_juridicas_url }
      format.json { head :no_content }
    end
  end
end
