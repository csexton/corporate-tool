require 'rails_helper'

RSpec.describe "Gists", type: :request do
  describe "GET /gists" do
    it "redirects when unauthenticated" do
      get gists_path
      expect(response.status).to be(302)
    end
  end
end
