require 'rails_helper'

RSpec.describe "Pages", :type => :request do
  let(:valid_attributes) {{ body: "# Silence Will Fall\n\nThe question must never be answered." }}
  let(:rory) {User.create!(name: 'Rory Williams', uid: "1")}

  describe "POST /preview" do
    it "redirects when unauthenticated" do
      post preview_path, params: valid_attributes
      expect(response.status).to be(302)
    end

    it "renders markdown content" do
      sign_in rory
      post preview_path, params: valid_attributes
      expect(response.body).to include '<h1 id="silence-will-fall">'
    end
  end
end
