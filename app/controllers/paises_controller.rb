# encoding: utf-8
class PaisesController < ApplicationController
  # GET /paises
  # GET /paises.json
  def index
    @paises = Pais
    
    @paises = @paises.where('nombre like ?', "%#{params[:nombre]}%") if params[:nombre].present?
    
    @paises = @paises.page(params[:page]).order('type, nombre').per(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paises }
    end
  end

  # GET /paises/1
  # GET /paises/1.json
  def show
    @pais = Pais.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pais }
    end
  end

  # GET /paises/new
  # GET /paises/new.json
  def new
    @pais = Pais.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pais }
    end
  end

  # GET /paises/1/edit
  def edit
    @pais = Pais.find(params[:id])
  end

  # POST /paises
  # POST /paises.json
  def create
    @pais = Pais.new(params[:pais])

    respond_to do |format|
      if @pais.save
        #format.html { redirect_to @pais, notice: 'País Creado Correctame.' }
        format.html { redirect_to paises_path, notice: 'País Creado Correctame.' }
        format.json { render json: @pais, status: :created, location: @pais }
      else
        format.html { render action: "new" }
        format.json { render json: @pais.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /paises/1
  # PUT /paises/1.json
  def update
    @pais = Pais.find(params[:id])

    respond_to do |format|
      if @pais.update_attributes(params[:pais])
        #format.html { redirect_to @pais, notice: 'País Modificado Correctamente.' }
        format.html { redirect_to paises_path, notice: 'País Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pais.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paises/1
  # DELETE /paises/1.json
  def destroy
    @pais = Pais.find(params[:id])
    begin
      @pais.destroy
      flash[:notice] = 'País Eliminado Correctamente.'
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede borrar'
    end

    respond_to do |format|
      format.html { redirect_to paises_url }
      format.json { head :no_content }
    end
  end
end
