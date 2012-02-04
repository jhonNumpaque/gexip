class TiposDocumentosController < ApplicationController
	before_filter :authenticate_usuario!
  # GET /tipos_documentos
  # GET /tipos_documentos.json
  def index
    @tipos_documentos = TipoDocumento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipos_documentos }
    end
  end

  # GET /tipos_documentos/1
  # GET /tipos_documentos/1.json
  def show
    @tipo_documento = TipoDocumento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_documento }
    end
  end

  # GET /tipos_documentos/new
  # GET /tipos_documentos/new.json
  def new
    @tipo_documento = TipoDocumento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_documento }
    end
  end

  # GET /tipos_documentos/1/edit
  def edit
    @tipo_documento = TipoDocumento.find(params[:id])
  end

  # POST /tipos_documentos
  # POST /tipos_documentos.json
  def create
    @tipo_documento = TipoDocumento.new(params[:tipo_documento])

    respond_to do |format|
      if @tipo_documento.save
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully created.' }
        format.json { render json: @tipo_documento, status: :created, location: @tipo_documento }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_documentos/1
  # PUT /tipos_documentos/1.json
  def update
    @tipo_documento = TipoDocumento.find(params[:id])

    respond_to do |format|
      if @tipo_documento.update_attributes(params[:tipo_documento])
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_documentos/1
  # DELETE /tipos_documentos/1.json
  def destroy
    @tipo_documento = TipoDocumento.find(params[:id])
    @tipo_documento.destroy

    respond_to do |format|
      format.html { redirect_to tipos_documentos_url }
      format.json { head :no_content }
    end
  end
end
