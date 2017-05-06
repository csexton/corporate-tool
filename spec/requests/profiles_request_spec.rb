require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:rory) { User.create!(name: 'Rory', uid: "1")}

  describe "GET #edit" do
    it "returns http success" do
      sign_in rory
      get profile_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #update" do
    it "updates the user's name"
  end

end
