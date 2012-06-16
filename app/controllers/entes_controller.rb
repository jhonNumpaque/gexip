class EntesController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /entes
  # GET /entes.json
  def index
    @entes = Ente
    
    if params[:valor].present?
      case params[:tipo]
      when 'DOCUMENTO'
        @entes = @entes.where(" documento = ?", params[:valor])
      when 'NOMBRE'
        @entes = @entes.where(" nombre like ? ", "%#{params[:valor]}%")
      when 'APELLIDO'
        @entes = @entes.where(" apellido like ?", "%#{params[:valor]}%")
      when 'DIRECCION'
        @entes = @entes.where(" direccion like ?", "%#{params[:valor]}%")
      when 'TELEFONO'
        @entes = @entes.where(" telefono = ?", params[:valor])
      else
        @entes = @entes.where(" documento = ? or nombre like ? or apellido like ? or direccion like ? or telefono = ?", params[:valor], "%#{params[:valor]}%", "%#{params[:valor]}%", "%#{params[:valor]}%", params[:valor])
      end
    end
    
    @entes = @entes.where(" tipo_documento_id = ?", params[:filtro_tipo_doc]) if params[:filtro_tipo_doc].present?
    @entes = @entes.where(" territorio_id = ?", params[:filtro_ciudad]) if params[:filtro_ciudad].present?
    
    @entes = @entes.page(params[:page]).per(10)

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
        format.html { redirect_to entes_path, notice: 'Ente Creado Correctamente.' }
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
        format.html { redirect_to entes_path, notice: 'Ente Modificado Correctamente.' }
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
      format.html { redirect_to entes_url, notice: 'Ente Eliminado Correctamente.' }
      format.json { head :no_content }
    end
  end
  
  def search
    @entes = Ente
    @entes = @entes.search(params[:form], params[:search], params[:documento], params[:nombre])
    @entes = @entes.page(params[:page]).per(10)
    
    respond_to do |format|
      format.js
    end
  end
end
