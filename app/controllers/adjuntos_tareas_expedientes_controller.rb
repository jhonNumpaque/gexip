class AdjuntosTareasExpedientesController < ApplicationController
  def new
    @adjunto_tarea_expediente = AdjuntoTareaExpediente.new
    @adjuntos = Adjunto.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adjunto_tarea_expediente }
      format.js
    end
  end

  def create
    adjuntos = params[:adjunto]
    tarea_expediente = params[:tarea_expediente]
    @expediente = Expediente.find(params[:expediente])

    respond_to do |format|
      if adjuntos.present?
        adjuntos.each do |key, a|
          #puts a.file_size
          @adjunto_tarea_expediente = AdjuntoTareaExpediente.new
          @adjunto_tarea_expediente.data = a
          @adjunto_tarea_expediente.adjunto_id = key #adjunto_id
          @adjunto_tarea_expediente.tarea_expediente_id = tarea_expediente
          @adjunto_tarea_expediente.save
        end
        format.html { redirect_to expediente_path(@expediente) }
      else
        format.html { redirect_to expediente_path(@expediente) }
      end
    end
  end

  def destroy
    @adjunto_tarea_expediente = AdjuntoTareaExpediente.find(params[:id])
    @expediente = Expediente.find(@adjunto_tarea_expediente.tarea_expediente.expediente_id)
    @adjunto_tarea_expediente.destroy

    respond_to do |format|
      format.html { redirect_to expediente_path(@expediente) }
      format.json { head :no_content }
    end
  end

  def download_file
    @adjunto_tarea_expediente = AdjuntoTareaExpediente.find(params[:id])
    @expediente = Expediente.find(@adjunto_tarea_expediente.tarea_expediente.expediente_id)


    path_o = "#{Rails.root}/public/" + @adjunto_tarea_expediente.data.url
    send_file path_o

  end

end