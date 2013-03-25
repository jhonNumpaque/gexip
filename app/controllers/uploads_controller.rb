class UploadsController < ApplicationController
  def create
    adjunto = Adjunto.new

    uploader = AdjuntoUploader.new
    uploader.store!(params['file'])    

    render :text => 'alert("hola")'
  end
end
