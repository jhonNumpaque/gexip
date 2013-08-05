class TiemposDemoradosController < ApplicationController
  #before_filter :authenticate_usuario!

  # GET /tiempos_demorados/
  def index
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organismos_internos }
    end
  end

  # GET /tiempos_demorados/listar/
  def listar

    @tiempos_demorados    


    if params[:tiempos_demorados][:fecha1].present? && params[:tiempos_demorados][:fecha2].present?

      fecha1 = Date.strptime(params[:tiempos_demorados][:fecha1], "%m-%d-%Y")
      fecha2 = Date.strptime(params[:tiempos_demorados][:fecha2], "%m-%d-%Y")
      #para saber que tipo de reporte voy a utilizar
      filtro = params[:tiempos_demorados][:filtro]

      if(filtro=="1")
        if params[:tiempos_demorados][:procedimineto_id].present?
          procedimineto_id = params[:tiempos_demorados][:procedimineto_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_601(fecha1.to_s(:db), fecha2.to_s(:db), procedimineto_id)
        end
      elsif (filtro=="2")
        if params[:tiempos_demorados][:cargo_id].present?
          cargo_id = params[:tiempos_demorados][:cargo_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_602(fecha1.to_s(:db), fecha2.to_s(:db), cargo_id)
        end
      end

    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organismo_interno }
    end

  end


end