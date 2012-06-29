class OrganismosInternosController < ApplicationController
  # GET /organismos_internos
  # GET /organismos_internos.json
  def index
    @organismos_internos = OrganismoInterno

    if params[:valor].present?
      case params[:tipo_busqueda]
      when "NOMBRE"
        @organismos_internos = @organismos_internos.where(" nombre LIKE ? ", "%"+params[:valor]+"%")
      when "DOCUMENTO"
        @organismos_internos = @organismos_internos.where(" documento LIKE ? ", "%"+params[:valor]+"%")
      else
        @organismos_internos = @organismos_internos.where(" nombre LIKE ? OR documento LIKE ? ", "%"+params[:valor]+"%","%"+params[:valor]+"%")
      end
      @organismos_internos = @organismos_internos.page(params[:page]).order('id').per(50)
    elsif params[:filtro_ciudad].present?
      @organismos_internos = @organismos_internos.where(" territorio_id = ? ", params[:filtro_ciudad])
      @organismos_internos = @organismos_internos.page(params[:page]).order('id').per(50)
    else
      #@usuarios = Usuario.all
      @organismos_internos = OrganismoInterno.page(params[:page]).order('id').per(50)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organismos_internos }
    end
  end

  # GET /organismos_internos/1
  # GET /organismos_internos/1.json
  def show
    @organismo_interno = OrganismoInterno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organismo_interno }
    end
  end

  # GET /organismos_internos/new
  # GET /organismos_internos/new.json
  def new
    @organismo_interno = OrganismoInterno.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organismo_interno }
    end
  end

  # GET /organismos_internos/1/edit
  def edit
    @organismo_interno = OrganismoInterno.find(params[:id])
  end

  # POST /organismos_internos
  # POST /organismos_internos.json
  def create
    @organismo_interno = OrganismoInterno.new(params[:organismo_interno])

    respond_to do |format|
      if @organismo_interno.save
        format.html { redirect_to organismos_internos_path, notice: 'Organismo Interno Creado Correctamente.' }
        format.json { render json: @organismo_interno, status: :created, location: @organismo_interno }
      else
        format.html { render action: "new" }
        format.json { render json: @organismo_interno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organismos_internos/1
  # PUT /organismos_internos/1.json
  def update
    @organismo_interno = OrganismoInterno.find(params[:id])

    respond_to do |format|
      if @organismo_interno.update_attributes(params[:organismo_interno])
        format.html { redirect_to organismos_internos_path, notice: 'Organismo Interno Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organismo_interno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organismos_internos/1
  # DELETE /organismos_internos/1.json
  def destroy
    @organismo_interno = OrganismoInterno.find(params[:id])

    begin
      @organismo_interno.destroy
      flash[:notice] = "Organismo Interno Eliminado Correctamente."
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar el Organismo Interno!.'  
    end


    respond_to do |format|
      format.html { redirect_to organismos_internos_url }
      format.json { head :no_content }
    end
  end
end
