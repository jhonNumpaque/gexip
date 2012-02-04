class RolesController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /roles
  # GET /roles.json
  def index
    @roles = Rol.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @rol = Rol.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rol }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @rol = Rol.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rol }
    end
  end

  # GET /roles/1/edit
  def edit
    @rol = Rol.find(params[:id])
  end

  # POST /roles
  # POST /roles.json
  def create
    @rol = Rol.new(params[:rol])

    respond_to do |format|
      if @rol.save
        format.html { redirect_to @rol, notice: 'Rol creado!' }
        format.json { render json: @rol, status: :created, location: @rol }
      else
        format.html { render action: "new" }
        format.json { render json: @rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    @rol = Rol.find(params[:id])

    respond_to do |format|
      if @rol.update_attributes(params[:rol])
        format.html { redirect_to @rol, notice: 'Rol was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @rol = Rol.find(params[:id])
    @rol.destroy

    respond_to do |format|
      format.html { redirect_to roles_url }
      format.json { head :no_content }
    end
  end
end
