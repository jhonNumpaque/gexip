class ControlesController < ApplicationController
  # GET /controles
  # GET /controles.json
  def index
    @controles = Control.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controles }
    end
  end

  # GET /controles/1
  # GET /controles/1.json
  def show
    @control = Control.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @control }
    end
  end

  # GET /controles/new
  # GET /controles/new.json
  def new
    @control = Control.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @control }
    end
  end

  # GET /controles/1/edit
  def edit
    @control = Control.find(params[:id])
  end

  # POST /controles
  # POST /controles.json
  def create
    @control = Control.new(params[:control])

    respond_to do |format|
      if @control.save
        format.html { redirect_to @control, notice: 'Control was successfully created.' }
        format.json { render json: @control, status: :created, location: @control }
      else
        format.html { render action: "new" }
        format.json { render json: @control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controles/1
  # PUT /controles/1.json
  def update
    @control = Control.find(params[:id])

    respond_to do |format|
      if @control.update_attributes(params[:control])
        format.html { redirect_to @control, notice: 'Control was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controles/1
  # DELETE /controles/1.json
  def destroy
    @control = Control.find(params[:id])
    @control.destroy

    respond_to do |format|
      format.html { redirect_to controles_url }
      format.json { head :no_content }
    end
  end
end
