require 'rails_helper'

RSpec.describe "Gists", type: :request do
  describe "GET /gists" do
    it "redirects when unauthenticated" do
      get gists_path
      expect(response.status).to be(302)
    end
  end


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
      sign_in rory
      gist = Gist.create! valid_attributes
      get gists_path

      expect(response.body).to include("Test Gist")
    end
  end

  describe "GET show" do
    it "assigns the requested gist as @gist" do
      sign_in rory
      gist = Gist.create! valid_attributes
      get gist_path(gist)

      expect(response.body).to include("Test Gist")
    end
  end

  describe "GET new" do
    it "assigns a new gist as @gist" do
      sign_in rory
      get new_gist_path
      expect(response.body).to include("gist[gist_files_attributes][0][file_name]")
    end
  end

  describe "GET edit" do
    it "assigns the requested gist as @gist" do
      sign_in rory
      gist = Gist.create! valid_attributes
      get edit_gist_path(gist)
      expect(response.body).to include("Test Gist")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Gist" do
        sign_in rory
        expect {
          post gists_path, params: {gist: valid_attributes}
        }.to change(Gist, :count).by(1)
      end

      it "redirects to the created gist" do
        sign_in rory
        post gists_path, params: {gist: valid_attributes}
        expect(response).to redirect_to(Gist.last)
      end
    end

    describe "with valid params and nested gist_files" do
      it "creates new gist files" do
        sign_in rory
        expect {
        post gists_path, params: {gist: valid_attributes_with_nested_gist_files}
        }.to change(GistFile, :count).by(2)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved gist as @gist" do
        sign_in rory
        post gists_path, params: {gist: invalid_attributes}
        expect(response.body).to include("be blank")
      end

      it "re-renders the 'new' template" do
        sign_in rory
        post gists_path, params: {gist: invalid_attributes}
        expect(response.body).to include("be blank")
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
        sign_in rory
        gist = Gist.create! valid_attributes
        put gist_path(gist, params: {gist: new_attributes})
        gist.reload
        expect(gist.description).to eq("Timey wimey")
      end

      it "redirects to the gist" do
        sign_in rory
        gist = Gist.create! valid_attributes
        put gist_path(gist, params: {gist: new_attributes})
        expect(response).to redirect_to(gist)
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        sign_in rory
        gist = Gist.create! valid_attributes
        put gist_path(gist, params: {gist: invalid_attributes})
        expect(response.body).to include("be blank")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested gist" do
        sign_in rory
        gist = Gist.create! valid_attributes
      expect {
        delete gist_path(gist)
      }.to change(Gist, :count).by(-1)
    end

    it "redirects to the gists list" do
      sign_in rory
      gist = Gist.create! valid_attributes
      delete gist_path(gist)
      expect(response).to redirect_to(gists_url)
    end
  end

end
