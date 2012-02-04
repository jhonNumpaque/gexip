class EntesController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /entes
  # GET /entes.json
  def index
    @entes = Ente.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entes }
    end
  end

  # GET /entes/1
  # GET /entes/1.json
  def show
    @ente = Ente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ente }
    end
  end

  # GET /entes/new
  # GET /entes/new.json
  def new
    @ente = Ente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ente }
    end
  end

  # GET /entes/1/edit
  def edit
    @ente = Ente.find(params[:id])
  end

  # POST /entes
  # POST /entes.json
  def create
    @ente = Ente.new(params[:ente])

    respond_to do |format|
      if @ente.save
        format.html { redirect_to @ente, notice: 'Ente was successfully created.' }
        format.json { render json: @ente, status: :created, location: @ente }
      else
        format.html { render action: "new" }
        format.json { render json: @ente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entes/1
  # PUT /entes/1.json
  def update
    @ente = Ente.find(params[:id])

    respond_to do |format|
      if @ente.update_attributes(params[:ente])
        format.html { redirect_to @ente, notice: 'Ente was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entes/1
  # DELETE /entes/1.json
  def destroy
    @ente = Ente.find(params[:id])
    @ente.destroy

    respond_to do |format|
      format.html { redirect_to entes_url }
      format.json { head :no_content }
    end
  end
end
