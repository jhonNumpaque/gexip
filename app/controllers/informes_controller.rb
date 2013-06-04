class InformesController < ApplicationController
  def index
  end

  def mostrar_formulario

  	@tipo_informe = params[:tipo_informe]

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipo_informe }
    end

  end
end
