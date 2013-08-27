class ActividadesController < ApplicationController
	
	def agregar_tarea
		@tarea = Tarea.new(:actividad_id => params[:actividad_id])
		@actividad_id = params[:actividad_id]
		
		respond_to do |format|
			format.js
		end
	end
	
	def listar_tareas
		@tareas = Tarea.where(:actividad_id => params[:actividad_id]).order("orden")
		@actividad_id = params[:actividad_id]

		respond_to do |format|
			format.js
		end
	end

	def show
		@actividad = Actividad.find(params[:id])
		@tareas = @actividad.tareas.order("orden")

		respond_to do |format|
			format.js
		end
	end

	def new
		@actividad = Actividad.new
		@actividad.procedimiento_id = params[:procedimiento_id]

		respond_to do |format|
			format.js
		end
	end

  def edit
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @actividad = Actividad.new(params[:actividad])

    respond_to do |format|
      @actividad.save
      format.js
    end
  end

  def update
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      @actividad.update_attributes(params[:actividad])
    	format.js
    end
  end

  def destroy
    @actividad = Actividad.find(params[:id])
    @actividad.destroy

    respond_to do |format|
      format.js
    end
  end
	
end