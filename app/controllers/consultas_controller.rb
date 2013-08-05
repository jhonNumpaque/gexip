class ConsultasController < ApplicationController
	layout "consultas"
	def index
		respond_to do |format|
    	  format.html { render layout: "formulario_consultas" }# show.html.erb
    	end
    end

    def show
    	respond_to do |format|
    	  format.html # show.html.erb
    	end
    end

    def verificar_expediente
    	documento = params[:documento]
    	password = params[:password]

		#buscar el ente que introduco el expediente
		ente = Ente.where(:documento => documento).first
		if ente.present?
			@expediente = Expediente
			@expediente = @expediente.where(:ente_id => ente.id, :clave => password)
			@expediente = @expediente.first

			@tareas_expedientes = TareaExpediente.where(:expediente_id => @expediente.id)
			@tareas_expedientes = @tareas_expedientes.order("created_at DESC")
		end

		
		respond_to do |format|
			if @expediente.present?
				format.html { render action: "show" }
			else
				format.html { redirect_to consultas_url, :flash => { :error => "Datos Inocorrectos!" }}
			end
		end
		
	end
end
