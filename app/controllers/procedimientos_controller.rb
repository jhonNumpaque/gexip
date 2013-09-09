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
      format.json { render json: [@procedimiento, @actividades] }
      format.js
    end
  end

  # GET /procedimientos/new
  # GET /procedimientos/new.json
  def new
    @procedimiento = Procedimiento.new

		actividad = @procedimiento.actividades.build
    @from_tree = params[:from].present?
    @subproceso_id = params[:subproceso_id].present? ? params[:subproceso_id] : params[:proceso_id]
		
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def buscar
		cond = []
		query_str = []
		query_val = {}

    #traer todos los procedimientos que se permiten al cargo del usuario
    cargo_estructura = CargoEstructura.find(current_usuario.funcionario.cargo_estructura_id)
    @procedimientos = cargo_estructura.procedimientos
    if params[:nombre].present?
			query_str << 'nombre ilike :nombre'
			query_val[:nombre] = "%#{params[:nombre]}%"
		end
		if query_str.present?
			cond[0] = query_str.join('and')
			cond[1] = query_val
		end

		#@procedimientos = Procedimiento.aprobados.where(cond).page(params[:page]).per(10)
		@procedimientos = @procedimientos.where(cond).page(params[:page]).per(10)

		respond_to do |format|
			format.js
		end
  end

  def comprobar_adjuntos
		@procedimiento = Procedimiento.find(params[:procedimiento_id])

		@adjuntos = @procedimiento.actividades.order('orden').first.tareas.order('orden').first.adjuntos if @procedimiento

		puts "---------------------------"
		puts @adjuntos.inspect

		respond_to do |format|
			format.js
		end
  end

  # GET /procedimientos/1/edit
  def edit
    @from_tree = params[:from].present?
    @procedimiento = Procedimiento.find(params[:id])
    @subproceso_id = @procedimiento.serieproceso_id
  end

  # POST /procedimientos
  # POST /procedimientos.json
  def create
    @procedimiento = Procedimiento.new(params[:procedimiento])

    respond_to do |format|
      if @procedimiento.save
        format.html { redirect_to @procedimiento, notice: 'Procedimiento creado!.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
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
        format.js
      rescue ActiveRecord::DeleteRestrictionError
        flash[:alert] = "No puede eliminar la Actividad!" 
        format.html { render action: "edit" }
        format.js
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
    rescue ActiveRecord::DeleteRestrictionError
      @error = "El procedimiento no puede ser eliminado!"
    end

    respond_to do |format|
      format.html { redirect_to procedimientos_url }
      format.js
    end
  end

  def aprobables
    @a_aprobar = Procedimiento.a_aprobar
    aprobados = Procedimiento.aprobados.includes(:version_aprobada => :version)
    @aprobados = []
    aprobados.each do |ap|
	    if ap.versions.length > 1
		    @aprobados << ap.version_aprobada.version.reify
	    else
		    @aprobados << ap
			end
    end
    @borradores = Procedimiento.borradores
  end

  def aprobar
		procedimiento = Procedimiento.find(params[:id])
		case params[:tipo]
			when 'aprobar' then
				procedimiento.aprobar!
				flash[:notice] = 'Procedimiento aprobado!'
			when 'desaprobar' then
				procedimiento.desaprobar!
				flash[:notice] = 'Procedimiento desaprobado!'
		end

		redirect_to :aprobables
  end

  def bloquear
		procedimiento = Procedimiento.find(params[:id])
		puts params[:tipo]
		puts params[:tipo].class
		params[:tipo] == "true" ? procedimiento.desbloquear! : procedimiento.bloquear!

		redirect_to :aprobables
  end

  def comprobar
		@procedimiento = Procedimiento.find(params[:procedimiento_id])
		actividades_completadas = @procedimiento.actividades_completas?
		@finalizado = actividades_completadas && @procedimiento.finalizado?
		@procedimiento.solicitar_autorizacion

		respond_to do |format|
		 format.js
		end
  end

  def new_index
    @macroprocesos = Macroproceso.all
    render :layout => 'jstree'
  end  

  def jstree
    if params[:operation] == 'search'
      data = []
      data << Procedimiento.where('nombre like ?', "%#{params[:search_str]}%").all
      data << Serieproceso.where('nombre like ?', "%#{params[:search_str]}%").all
      data << Actividad.where('descripcion like ?', "%#{params[:search_str]}%").all

      data.flatten!
      
      response = data.map { |d| { attr: { id: "node_#{d.id}", rel: d.class.to_s.downcase, type: d.class.to_s.downcase  }, data: d.nombre, state: 'open' }}
    else
      if params[:id] == '0'
        data = Macroproceso.all
      else      
        if params[:type] == 'proceso' || params[:type] == 'subproceso'
          data = Procedimiento.where(serieproceso_id: params[:id]).all
          data.concat(Serieproceso.where(serieproceso_id: params[:id]).all)
          data.compact!
        elsif params[:type] == 'procedimiento'
          data = Actividad.where(procedimiento_id: params[:id]).order('orden').all      
        else
          data = Serieproceso.where(serieproceso_id: params[:id]).all
        end
        
        #image = data.first ? data.first.type : nil
      end
      response = data.map { |d| { attr: { id: "#{d.class.to_s.downcase}_#{d.id}", rel: d.class.to_s.downcase, type: d.class.to_s.downcase  }, data: d.nombre, state: d.tree_state }}
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
