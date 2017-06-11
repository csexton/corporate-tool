require 'rails_helper'

RSpec.describe "Pages", :type => :request do
  let(:valid_attributes) {{ body: "# header 1\n\nbody" }}
  let(:rory) {User.create!(name: 'Rory', uid: "1")}

  describe "POST /preview" do
    it "redirects when unauthenticated" do
      post preview_path, params: valid_attributes
      expect(response.status).to be(302)
    end

    it "renders markdown content" do
      sign_in rory
      post preview_path, params: valid_attributes
      expect(response.body).to include '<h1 id="header-1">'
    end
  end
end
