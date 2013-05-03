class ProcesosController < ApplicationController
  # GET /procesos
  # GET /procesos.json
  def index
    @procesos = Proceso
    
    if params[:valor].present?
      case params[:tipo_busqueda]
      when 'NOMBRE'
        @procesos = @procesos.where(' nombre like ?', "%#{params[:valor]}%")
      when 'OBJETIVO'
        @procesos = @procesos.where(' objetivo like ?', "%#{params[:valor]}%")
      when 'CODIGO'
        @procesos = @procesos.where(' codigo =  ?', "#{params[:valor]}")
      else
        @procesos = @procesos.where(' nombre like ? or objetivo like ? or codigo = ?', "%#{params[:valor]}%", "%#{params[:valor]}%", "%#{params[:valor]}%")
      end
    end
    
    @procesos = @procesos.where(:serieproceso_id => params[:macroproceso_id]) if (params[:macroproceso_id].present?)
    @procesos = @procesos.where(:cargo_id => params[:filtro_cargo]) if (params[:filtro_cargo].present?)
    @procesos = @procesos.page(params[:page]).per(10)
    
    @macroprocesos = Macroproceso.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @procesos }
    end
  end

  # GET /procesos/1
  # GET /procesos/1.json
  def show
    @proceso = Proceso.find(params[:id])
    @subprocesos = @proceso.subprocesos

    respond_to do |format|
      format.html # show.html.erb
      format.json do         
        render json: [@proceso, @subprocesos]
      end
      format.js
    end
  end

  # GET /procesos/new
  # GET /procesos/new.json
  def new
    @proceso = Proceso.new
    @from_tree = params[:from].present? && params[:from] == 'tree'

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /procesos/1/edit
  def edit
    @proceso = Proceso.find(params[:id])
    @from_tree = params[:from].present? && params[:from] == 'tree'

    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /procesos
  # POST /procesos.json
  def create
    @proceso = Proceso.new(params[:proceso])

    respond_to do |format|
      if @proceso.save
        format.html { redirect_to procesos_path, notice: 'Proceso Creado Correctamente.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  # PUT /procesos/1
  # PUT /procesos/1.json
  def update
    @proceso = Proceso.find(params[:id])

    respond_to do |format|
      if @proceso.update_attributes(params[:proceso])
        format.html { redirect_to procesos_path, notice: 'Proceso Modificado Correctamente.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @proceso.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /procesos/1
  # DELETE /procesos/1.json
  def destroy
    @proceso = Proceso.find(params[:id])
    begin
      @proceso.destroy
      flash[:notice] = "Proceso Eliminado!"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "No se puede eliminar el Proceso!"
    end

    respond_to do |format|
      format.html { redirect_to procesos_url}
      format.js
    end
  end
  
  # GET /procesos/imprimir/reporte_formato_38?
  def reporte_formato_38
    #    @procesos = Proceso
    #    @macroproceso = MacroProceso
    #    if (params[:macroproceso_id].present?)
    @procesos = Proceso.where(:serieproceso_id => params[:macroproceso_id])
    @macroproceso = Macroproceso.find(params[:macroproceso_id])
    #    end
    
    respond_to do |format|
      format.html { render :layout => "popup_wf" } # show.html.erb
      #format.json { render json: @macroproceso }
    end
  end
  
end
