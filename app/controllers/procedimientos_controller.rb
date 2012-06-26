class ProcedimientosController < ApplicationController
  # GET /procedimientos
  # GET /procedimientos.json
  def index
    @procedimientos = Procedimiento
		
    @procedimientos = @procedimientos.where(" nombre like ?", "%#{params[:nombre]}%") if params[:nombre].present?
    @procedimientos = @procedimientos.where(" objetivo like ?", "%#{params[:objetivo]}%") if params[:objetivo].present?
    @procedimientos = @procedimientos.where(" definicion like ?", "%#{params[:definicion]}%") if params[:definicion].present?
    @procedimientos = @procedimientos.where(" serieproceso_id = ?", params[:subproceso]) if params[:subproceso].present?
    
    @procedimientos = @procedimientos.page(params[:page]).per(10)
		
		
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @procedimientos }
      format.js
    end
  end

  # GET /procedimientos/1
  # GET /procedimientos/1.json
  def show
    @procedimiento = Procedimiento.find(params[:id])
    @actividades = @procedimiento.actividades.order('orden asc')
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @procedimiento }
    end
  end

  # GET /procedimientos/new
  # GET /procedimientos/new.json
  def new
    @procedimiento = Procedimiento.new

		actividad = @procedimiento.actividades.build
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @procedimiento }
    end
  end

  # GET /procedimientos/1/edit
  def edit
    @procedimiento = Procedimiento.find(params[:id])
  end

  # POST /procedimientos
  # POST /procedimientos.json
  def create
    @procedimiento = Procedimiento.new(params[:procedimiento])

    respond_to do |format|
      if @procedimiento.save
        format.html { redirect_to @procedimiento, notice: 'Procedimiento creado!.' }
        format.json { render json: @procedimiento, status: :created, location: @procedimiento }
      else
        format.html { render action: "new" }
        format.json { render json: @procedimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /procedimientos/1
  # PUT /procedimientos/1.json
  def update
    @procedimiento = Procedimiento.find(params[:id])

    respond_to do |format|
      #      if @procedimiento.update_attributes(params[:procedimiento])
      #        format.html { redirect_to @procedimiento, notice: 'Procedimiento modificado!.' }
      #        format.json { head :no_content }
      #      else
      #        format.html { render action: "edit" }
      #        format.json { render json: @procedimiento.errors, status: :unprocessable_entity }
      #      end

      #a causa del nested attributes, al realizar el update, verificar que no ocurran problemas
      begin
        @procedimiento.update_attributes(params[:procedimiento])
        format.html { redirect_to @procedimiento, notice: 'Procedimiento modificado!.' }
        format.json { head :no_content }
      rescue ActiveRecord::DeleteRestrictionError
        flash[:alert] = "No puede eliminar la Actividad!" 
        format.html { render action: "edit" }
        format.json { render json: @procedimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedimientos/1
  # DELETE /procedimientos/1.json
  def destroy
    @procedimiento = Procedimiento.find(params[:id])
    
    begin
      @procedimiento.destroy
      flash[:notice] = "Procedimiento Eliminado!"
    rescue ActiveRedord::DeleteRestrictionError
      flash[:alert] = "El procedimiento no puede ser eliminado!"
    end

    respond_to do |format|
      format.html { redirect_to procedimientos_url }
      format.json { head :no_content }
    end
  end
end
