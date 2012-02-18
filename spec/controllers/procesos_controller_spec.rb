require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProcesosController do

  # This should return the minimal set of attributes required to create a valid
  # Proceso. As you add validations to Proceso, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProcesosController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all procesos as @procesos" do
      proceso = Proceso.create! valid_attributes
      get :index, {}, valid_session
      assigns(:procesos).should eq([proceso])
    end
  end

  describe "GET show" do
    it "assigns the requested proceso as @proceso" do
      proceso = Proceso.create! valid_attributes
      get :show, {:id => proceso.to_param}, valid_session
      assigns(:proceso).should eq(proceso)
    end
  end

  describe "GET new" do
    it "assigns a new proceso as @proceso" do
      get :new, {}, valid_session
      assigns(:proceso).should be_a_new(Proceso)
    end
  end

  describe "GET edit" do
    it "assigns the requested proceso as @proceso" do
      proceso = Proceso.create! valid_attributes
      get :edit, {:id => proceso.to_param}, valid_session
      assigns(:proceso).should eq(proceso)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Proceso" do
        expect {
          post :create, {:proceso => valid_attributes}, valid_session
        }.to change(Proceso, :count).by(1)
      end

      it "assigns a newly created proceso as @proceso" do
        post :create, {:proceso => valid_attributes}, valid_session
        assigns(:proceso).should be_a(Proceso)
        assigns(:proceso).should be_persisted
      end

      it "redirects to the created proceso" do
        post :create, {:proceso => valid_attributes}, valid_session
        response.should redirect_to(Proceso.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved proceso as @proceso" do
        # Trigger the behavior that occurs when invalid params are submitted
        Proceso.any_instance.stub(:save).and_return(false)
        post :create, {:proceso => {}}, valid_session
        assigns(:proceso).should be_a_new(Proceso)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Proceso.any_instance.stub(:save).and_return(false)
        post :create, {:proceso => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested proceso" do
        proceso = Proceso.create! valid_attributes
        # Assuming there are no other procesos in the database, this
        # specifies that the Proceso created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Proceso.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => proceso.to_param, :proceso => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested proceso as @proceso" do
        proceso = Proceso.create! valid_attributes
        put :update, {:id => proceso.to_param, :proceso => valid_attributes}, valid_session
        assigns(:proceso).should eq(proceso)
      end

      it "redirects to the proceso" do
        proceso = Proceso.create! valid_attributes
        put :update, {:id => proceso.to_param, :proceso => valid_attributes}, valid_session
        response.should redirect_to(proceso)
      end
    end

    describe "with invalid params" do
      it "assigns the proceso as @proceso" do
        proceso = Proceso.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Proceso.any_instance.stub(:save).and_return(false)
        put :update, {:id => proceso.to_param, :proceso => {}}, valid_session
        assigns(:proceso).should eq(proceso)
      end

      it "re-renders the 'edit' template" do
        proceso = Proceso.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Proceso.any_instance.stub(:save).and_return(false)
        put :update, {:id => proceso.to_param, :proceso => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested proceso" do
      proceso = Proceso.create! valid_attributes
      expect {
        delete :destroy, {:id => proceso.to_param}, valid_session
      }.to change(Proceso, :count).by(-1)
    end

    it "redirects to the procesos list" do
      proceso = Proceso.create! valid_attributes
      delete :destroy, {:id => proceso.to_param}, valid_session
      response.should redirect_to(procesos_url)
    end
  end

end