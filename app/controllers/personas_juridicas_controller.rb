class PersonasJuridicasController < ApplicationController
  # GET /personas_juridicas
  # GET /personas_juridicas.json
  def index
    @personas_juridicas = PersonaJuridica.all

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
        format.html { redirect_to @persona_juridica, notice: 'Persona juridica was successfully created.' }
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
        format.html { redirect_to @persona_juridica, notice: 'Persona juridica was successfully updated.' }
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
    @persona_juridica.destroy

    respond_to do |format|
      format.html { redirect_to personas_juridicas_url }
      format.json { head :no_content }
    end
  end
end
