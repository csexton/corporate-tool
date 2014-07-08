require 'rails_helper'

RSpec.describe GistsController, type: :controller do
  let(:rory) {User.create!(name: 'Rory', uid: "1")}
  let(:valid_attributes) { { description: "Test Gist", } }
  let(:valid_attributes_with_nested_gist_files) { { description: "Another Test", gist_files_attributes:
                                                        {
                                                          "0" => { file_type: 'ruby', body: 'puts "w00t"' },
                                                          "1" => { file_type: 'ruby', body: 'array.pop'}
                                                        }
  } }
  let(:invalid_attributes) { { description: nil, } }
  let(:valid_session) { { user_id: rory.id} }

  describe "GET index" do
    it "assigns all gists as @gists" do
      gist = Gist.create! valid_attributes
      get :index, {}, valid_session

      expect(assigns(:gists)).to eq([gist])
    end
  end

  describe "GET show" do
    it "assigns the requested gist as @gist" do
      gist = Gist.create! valid_attributes
      get :show, {id: gist.to_param}, valid_session
      expect(assigns(:gist)).to eq(gist)
    end
  end

  describe "GET new" do
    it "assigns a new gist as @gist" do
      get :new, {}, valid_session
      expect(assigns(:gist)).to be_a_new(Gist)
    end
  end

  describe "GET edit" do
    it "assigns the requested gist as @gist" do
      gist = Gist.create! valid_attributes
      get :edit, {id: gist.to_param}, valid_session
      expect(assigns(:gist)).to eq(gist)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Gist" do
        expect {
          post :create, {gist: valid_attributes}, valid_session
        }.to change(Gist, :count).by(1)
      end

      it "assigns a newly created gist as @gist" do
        post :create, {gist: valid_attributes}, valid_session
        expect(assigns(:gist)).to be_a(Gist)
        expect(assigns(:gist)).to be_persisted
      end

      it "redirects to the created gist" do
        post :create, {gist: valid_attributes}, valid_session
        expect(response).to redirect_to(Gist.last)
      end
    end

    describe "with valid params and nested gist_files" do
      it "creates new gist files" do
        expect {
          post :create, {gist: valid_attributes_with_nested_gist_files}, valid_session
        }.to change(GistFile, :count).by(2)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved gist as @gist" do
        post :create, {gist: invalid_attributes}, valid_session
        expect(assigns(:gist)).to be_a_new(Gist)
      end

      it "re-renders the 'new' template" do
        post :create, {gist: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          description: "Timey wimey",
        }
      }

      it "updates the requested gist" do
        gist = Gist.create! valid_attributes
        put :update, {id: gist.to_param, gist: new_attributes}, valid_session
        gist.reload
        expect(gist.description).to eq("Timey wimey")
      end

      it "assigns the requested gist as @gist" do
        gist = Gist.create! valid_attributes
        put :update, {id: gist.to_param, gist: valid_attributes}, valid_session
        expect(assigns(:gist)).to eq(gist)
      end

      it "redirects to the gist" do
        gist = Gist.create! valid_attributes
        put :update, {id: gist.to_param, gist: valid_attributes}, valid_session
        expect(response).to redirect_to(gist)
      end
    end

    describe "with invalid params" do
      it "assigns the gist as @gist" do
        gist = Gist.create! valid_attributes
        put :update, {id: gist.to_param, gist: invalid_attributes}, valid_session
        expect(assigns(:gist)).to eq(gist)
      end

      it "re-renders the 'edit' template" do
        gist = Gist.create! valid_attributes
        put :update, {id: gist.to_param, gist: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested gist" do
      gist = Gist.create! valid_attributes
      expect {
        delete :destroy, {id: gist.to_param}, valid_session
      }.to change(Gist, :count).by(-1)
    end

    it "redirects to the gists list" do
      gist = Gist.create! valid_attributes
      delete :destroy, {id: gist.to_param}, valid_session
      expect(response).to redirect_to(gists_url)
    end
  end

end
