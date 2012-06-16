class PersonasFisicasController < ApplicationController
  # GET /personas_fisicas
  # GET /personas_fisicas.json
  def index
    @personas_fisicas = PersonaFisica.all

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
  end

  # POST /personas_fisicas
  # POST /personas_fisicas.json
  def create
    @persona_fisica = PersonaFisica.new(params[:persona_fisica])

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
    @persona_fisica.destroy

    respond_to do |format|
      format.html { redirect_to personas_fisicas_url }
      format.json { head :no_content }
    end
  end
end
