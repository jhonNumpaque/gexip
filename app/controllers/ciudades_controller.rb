class CiudadesController < ApplicationController
  # GET /ciudades
  # GET /ciudades.json
  def index
    @ciudades = Ciudad
    
    @ciudades = @ciudades.where("nombre like ?", "%#{params[:nombre]}%") if params[:nombre].present?
    @ciudades = @ciudades.where("territorio_id = ?", params[:territorio_id]) if params[:territorio_id].present?
    
    @ciudades = @ciudades.page(params[:page]).order('type, nombre').per(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ciudades }
    end
  end

  # GET /ciudades/1
  # GET /ciudades/1.json
  def show
    @ciudad = Ciudad.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ciudad }
    end
  end

  # GET /ciudades/new
  # GET /ciudades/new.json
  def new
    @ciudad = Ciudad.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ciudad }
    end
  end

  # GET /ciudades/1/edit
  def edit
    @ciudad = Ciudad.find(params[:id])
  end

  # POST /ciudades
  # POST /ciudades.json
  def create
    @ciudad = Ciudad.new(params[:ciudad])

    respond_to do |format|
      if @ciudad.save
        format.html { redirect_to ciudades_path, notice: 'Ciudad Creada Correctamente.' }
        format.json { render json: @ciudad, status: :created, location: @ciudad }
      else
        format.html { render action: "new" }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ciudades/1
  # PUT /ciudades/1.json
  def update
    @ciudad = Ciudad.find(params[:id])

    respond_to do |format|
      if @ciudad.update_attributes(params[:ciudad])
        format.html { redirect_to ciudades_path, notice: 'Ciudad Modificada Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ciudades/1
  # DELETE /ciudades/1.json
  def destroy
    @ciudad = Ciudad.find(params[:id])
    begin
      @ciudad.destroy
      flash[:notice] = 'Ciudad Eliminada Correctamente.'
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar la Ciudad!'
    end
   
    respond_to do |format|
      format.html { redirect_to ciudades_url }
      format.json { head :no_content }
    end
  end
end
