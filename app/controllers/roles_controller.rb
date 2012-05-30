class RolesController < ApplicationController
	before_filter :authenticate_usuario!	
  
  # GET /roles
  # GET /roles.json
  def index
    @roles = Rol
    
    @roles = @roles.where("nombre like ?", "%#{params[:nombre]}%") if params[:nombre].present?
    
    @roles = @roles.page(params[:page]).per(10)    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @rol = Rol.find(params[:id])
    @permisos = Permiso.where(:permiso_id => nil, :publico => false).order('controlador')
    @permisos_actuales = @rol.permisos

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rol }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @rol = Rol.new
    @permisos = Permiso.where(:permiso_id => nil, :publico => false).order('controlador')
    @permisos_actuales = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rol }
    end
  end

  # GET /roles/1/edit
  def edit
    @rol = Rol.find(params[:id])
    @permisos = Permiso.where(:permiso_id => nil, :publico => false).order('controlador')
    @permisos_actuales = @rol.permisos
  end

  # POST /roles
  # POST /roles.json
  def create
    @rol = Rol.new(params[:rol])
    permisos = Permiso.where(:id => params[:permisos])
    @rol.permisos = permisos

    respond_to do |format|
      if @rol.save                                        
        format.html { redirect_to @rol, notice: 'Rol creado!' }
        format.json { render json: @rol, status: :created, location: @rol }
      else
        @permisos = Permiso.where(:permiso_id => nil, :publico => false)
        @permisos_actuales = permisos
        
        format.html { render action: "new" }
        format.json { render json: @rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    @rol = Rol.find(params[:id])
    permisos = Permiso.where(:id => params[:permisos])
    @rol.permisos = permisos

    respond_to do |format|
      if @rol.update_attributes(params[:rol])                
        format.html { redirect_to @rol, notice: 'Rol actualizado!.' }
        format.json { head :no_content }
      else
        @permisos = Permiso.where(:permiso_id => nil, :publico => false)
        @permisos_actuales = permisos
        
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
      format.html { redirect_to roles_url, notice: 'Rol eliminado!.' }
      format.json { head :no_content }
    end
  end
end
