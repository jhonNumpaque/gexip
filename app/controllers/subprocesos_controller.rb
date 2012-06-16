class SubprocesosController < ApplicationController
  # GET /subprocesos
  # GET /subprocesos.json
  def index
    @subprocesos = Subproceso
    
    if params[:valor].present?
      case params[:tipo_busqueda]
      when 'NOMBRE'
        @subprocesos = @subprocesos.where(' nombre like ?', "%#{params[:valor]}%")
      when 'OBJETIVO'
        @subprocesos = @subprocesos.where(' objetivo like ?', "%#{params[:valor]}%")
      when 'CODIGO'
        @subprocesos = @subprocesos.where(' codigo =  ?', "#{params[:valor]}")
      else
        @subprocesos = @subprocesos.where(' nombre like ? or objetivo like ? or codigo = ?', "%#{params[:valor]}%", "%#{params[:valor]}%", "%#{params[:valor]}%")
      end
    end
    
    @subprocesos = @subprocesos.where(:serieproceso_id => params[:proceso_id]) if (params[:proceso_id].present?)
    @subprocesos = @subprocesos.where(:cargo_id => params[:filtro_cargo]) if (params[:filtro_cargo].present?)
    @subprocesos = @subprocesos.page(params[:page]).per(10)
    
    @procesos = Proceso.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subprocesos }
    end
  end

  # GET /subprocesos/1
  # GET /subprocesos/1.json
  def show
    @subproceso = Subproceso.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subproceso }
    end
  end

  # GET /subprocesos/new
  # GET /subprocesos/new.json
  def new
    @subproceso = Subproceso.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subproceso }
    end
  end

  # GET /subprocesos/1/edit
  def edit
    @subproceso = Subproceso.find(params[:id])
  end

  # POST /subprocesos
  # POST /subprocesos.json
  def create
    @subproceso = Subproceso.new(params[:subproceso])

    respond_to do |format|
      if @subproceso.save
        format.html { redirect_to subprocesos_path, notice: 'Subproceso Creado Correctamente.' }
        format.json { render json: @subproceso, status: :created, location: @subproceso }
      else
        format.html { render action: "new" }
        format.json { render json: @subproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subprocesos/1
  # PUT /subprocesos/1.json
  def update
    @subproceso = Subproceso.find(params[:id])

    respond_to do |format|
      if @subproceso.update_attributes(params[:subproceso])
        format.html { redirect_to subproceso_path, notice: 'Subproceso Modificado Correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subprocesos/1
  # DELETE /subprocesos/1.json
  def destroy
    @subproceso = Subproceso.find(params[:id])
    begin
      @subproceso.destroy
      flash[:notice] = "Subproceso eliminado!"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "No se puede eliminar el Subproceso"
    end

    respond_to do |format|
      format.html { redirect_to subprocesos_url }
      format.json { head :no_content }
    end
  end
  
  # GET /subprocesos/imprimir/reporte_formato_39?
  def reporte_formato_39
    @subprocesos = Subproceso.where(:serieproceso_id => params[:proceso_id])
    @proceso = Proceso.find(params[:proceso_id])
    
    respond_to do |format|
      format.html { render :layout => "popup_wf" } # show.html.erb
      #format.json { render json: @macroproceso }
    end
  end
  
end
