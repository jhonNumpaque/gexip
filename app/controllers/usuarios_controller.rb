class UsuariosController < ApplicationController
	before_filter :authenticate_usuario!  
  
  # GET /usuarios
  # GET /usuarios.json
  def index
    
    @usuarios = Usuario
    
    
    if params[:valor].present?
      case params[:tipo_busqueda]
      when "USUARIO"
        @usuarios = @usuarios.where(" login LIKE ? ", "%"+params[:valor]+"%")
      when "NOMBRE"
        @usuarios = @usuarios.where(" nombres LIKE ? ", "%"+params[:valor]+"%")
      when "APELLIDO"
        @usuarios = @usuarios.where(" apellidos LIKE ? ", "%"+params[:valor]+"%")
      when "DOCUMENTO"
        @usuarios = @usuarios.where(" documento LIKE ? ", "%"+params[:valor]+"%")
      else
        @usuarios = @usuarios.where(" login LIKE ? OR nombres LIKE ? OR apellidos LIKE ? OR documento LIKE ? ", "%"+params[:valor]+"%","%"+params[:valor]+"%","%"+params[:valor]+"%","%"+params[:valor]+"%")
      end
      @usuarios = @usuarios.page(params[:page]).order('login').per(50)
    elsif params[:filtro_rol].present?
      @usuarios = @usuarios.where(" rol_id = ? ", params[:filtro_rol])
      @usuarios = @usuarios.page(params[:page]).order('login').per(50)
    else
      #@usuarios = Usuario.all
      @usuarios = Usuario.page(params[:page]).order('login').per(50)
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.json
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(params[:usuario])

    respond_to do |format|
      if @usuario.save
        #format.html { redirect_to @usuario, notice: 'Usuario creado!' }
        format.html { redirect_to usuarios_path, notice: 'Usuario Creado Correctame.' }
        format.json { render json: @usuario, status: :created, location: @usuario }
      else
        format.html { render action: "new" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.json
  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        #format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        format.html { redirect_to usuarios_path, notice: 'Usuario Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /usuarios/datos/cambiar_clave/2
  def cambiar_clave
    @usuario = Usuario.find(params[:id])
  end
  
  # PUT /usuarios/datos/cambiar_clave_grabar/2
  def cambiar_clave_grabar
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        #format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        #format.html { redirect_to @rol, notice: 'Rol actualizado!.' }
        format.html { redirect_to @usuario, notice: 'Clave Modificada Correctamente.' }
        #format.json { head :no_content }
      else
        format.html { render action: "cambiar_clave" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /usuarios/datos/modificar/1
  def modificar_datos
    @usuario = Usuario.find(params[:id])
  end
  
  # PUT /usuarios/datos/modificar_datos_grabar/2
  def modificar_datos_grabar
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        #format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        #format.html { redirect_to @rol, notice: 'Rol actualizado!.' }
        format.html { redirect_to @usuario, notice: 'Usuario Modificado Correctamente.' }
        #format.json { head :no_content }
      else
        format.html { render action: "cambiar_clave" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario = Usuario.find(params[:id])
    begin
      @usuario.destroy
      flash[:notice] = "Usuario Eliminado Correctamente."
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = 'No se puede eliminar el Usuario!.'  
    end

    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end
  
  def denegado
    
  end
  
end
