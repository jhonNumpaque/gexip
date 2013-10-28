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

      #fecha1 = Date.strptime(params[:tiempos_demorados][:fecha1], "%m-%d-%Y")
      #fecha2 = Date.strptime(params[:tiempos_demorados][:fecha2], "%m-%d-%Y")
      fecha1 = Date.parse(params[:tiempos_demorados][:fecha1])
      fecha2 = Date.parse(params[:tiempos_demorados][:fecha2])
      #para saber que tipo de reporte voy a utilizar
      filtro = params[:tiempos_demorados][:filtro]
      expediente = params[:tiempos_demorados][:expediente]

      if(filtro=="1" and expediente=="2")
        if params[:tiempos_demorados][:procedimineto_id].present?
          procedimineto_id = params[:tiempos_demorados][:procedimineto_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_601(fecha1.to_s(:db), fecha2.to_s(:db), procedimineto_id)
        end
      elsif (filtro=="2" and expediente=="2")
        if params[:tiempos_demorados][:cargo_id].present?
          cargo_id = params[:tiempos_demorados][:cargo_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_602(fecha1.to_s(:db), fecha2.to_s(:db), cargo_id)
        end
      elsif (filtro=="3" and expediente=="2")
        if params[:tiempos_demorados][:funcionario_id].present?
          funcionario_id = params[:tiempos_demorados][:funcionario_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_603(fecha1.to_s(:db), fecha2.to_s(:db), funcionario_id)
        end
      elsif (filtro=="1" and expediente=="1")
        if params[:tiempos_demorados][:procedimineto_id].present?
          procedimineto_id = params[:tiempos_demorados][:procedimineto_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_604(fecha1.to_s(:db), fecha2.to_s(:db), procedimineto_id)
        end
      elsif (filtro=="2" and expediente=="1")
        if params[:tiempos_demorados][:cargo_id].present?
          cargo_id = params[:tiempos_demorados][:cargo_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_605(fecha1.to_s(:db), fecha2.to_s(:db), cargo_id)
        end
      elsif (filtro=="3" and expediente=="1")
        if params[:tiempos_demorados][:funcionario_id].present?
          funcionario_id = params[:tiempos_demorados][:funcionario_id]
          @tiempos_demorados = TiempoDemorado.f_reporte_606(fecha1.to_s(:db), fecha2.to_s(:db), funcionario_id)
        end
      end

    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organismo_interno }
    end

  end


end