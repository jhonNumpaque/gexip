class ProcedimientosController < ApplicationController
  # GET /procedimientos
  # GET /procedimientos.json
  def index
    @procedimientos = Procedimiento.page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @procedimientos }
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
        format.html { redirect_to @procedimiento, notice: 'Procedimiento was successfully created.' }
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
      if @procedimiento.update_attributes(params[:procedimiento])
        format.html { redirect_to @procedimiento, notice: 'Procedimiento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @procedimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedimientos/1
  # DELETE /procedimientos/1.json
  def destroy
    @procedimiento = Procedimiento.find(params[:id])
    @procedimiento.destroy

    respond_to do |format|
      format.html { redirect_to procedimientos_url }
      format.json { head :no_content }
    end
  end
end
