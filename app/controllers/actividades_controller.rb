class ActividadesController < ApplicationController
	
	def agregar_tarea
		@tarea = Tarea.new(:actividad_id => params[:id])
		
		respond_to do |format|
			format.js
		end
	end
	
	def listar_tareas
		@tareas = Tarea.where(:actividad_id => params[:id]).order("orden")

		respond_to do |format|
			format.js
		end
	end
	
end