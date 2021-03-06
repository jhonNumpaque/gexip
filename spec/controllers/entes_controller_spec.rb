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

describe EntesController do

  # This should return the minimal set of attributes required to create a valid
  # Ente. As you add validations to Ente, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EntesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all entes as @entes" do
      ente = Ente.create! valid_attributes
      get :index, {}, valid_session
      assigns(:entes).should eq([ente])
    end
  end

  describe "GET show" do
    it "assigns the requested ente as @ente" do
      ente = Ente.create! valid_attributes
      get :show, {:id => ente.to_param}, valid_session
      assigns(:ente).should eq(ente)
    end
  end

  describe "GET new" do
    it "assigns a new ente as @ente" do
      get :new, {}, valid_session
      assigns(:ente).should be_a_new(Ente)
    end
  end

  describe "GET edit" do
    it "assigns the requested ente as @ente" do
      ente = Ente.create! valid_attributes
      get :edit, {:id => ente.to_param}, valid_session
      assigns(:ente).should eq(ente)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Ente" do
        expect {
          post :create, {:ente => valid_attributes}, valid_session
        }.to change(Ente, :count).by(1)
      end

      it "assigns a newly created ente as @ente" do
        post :create, {:ente => valid_attributes}, valid_session
        assigns(:ente).should be_a(Ente)
        assigns(:ente).should be_persisted
      end

      it "redirects to the created ente" do
        post :create, {:ente => valid_attributes}, valid_session
        response.should redirect_to(Ente.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ente as @ente" do
        # Trigger the behavior that occurs when invalid params are submitted
        Ente.any_instance.stub(:save).and_return(false)
        post :create, {:ente => {}}, valid_session
        assigns(:ente).should be_a_new(Ente)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Ente.any_instance.stub(:save).and_return(false)
        post :create, {:ente => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ente" do
        ente = Ente.create! valid_attributes
        # Assuming there are no other entes in the database, this
        # specifies that the Ente created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Ente.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => ente.to_param, :ente => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested ente as @ente" do
        ente = Ente.create! valid_attributes
        put :update, {:id => ente.to_param, :ente => valid_attributes}, valid_session
        assigns(:ente).should eq(ente)
      end

      it "redirects to the ente" do
        ente = Ente.create! valid_attributes
        put :update, {:id => ente.to_param, :ente => valid_attributes}, valid_session
        response.should redirect_to(ente)
      end
    end

    describe "with invalid params" do
      it "assigns the ente as @ente" do
        ente = Ente.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ente.any_instance.stub(:save).and_return(false)
        put :update, {:id => ente.to_param, :ente => {}}, valid_session
        assigns(:ente).should eq(ente)
      end

      it "re-renders the 'edit' template" do
        ente = Ente.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ente.any_instance.stub(:save).and_return(false)
        put :update, {:id => ente.to_param, :ente => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested ente" do
      ente = Ente.create! valid_attributes
      expect {
        delete :destroy, {:id => ente.to_param}, valid_session
      }.to change(Ente, :count).by(-1)
    end

    it "redirects to the entes list" do
      ente = Ente.create! valid_attributes
      delete :destroy, {:id => ente.to_param}, valid_session
      response.should redirect_to(entes_url)
    end
  end

end
