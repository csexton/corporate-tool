require 'rails_helper'

RSpec.describe "Pages", :type => :request do
  describe "GET /pages" do
    it "redirects when unauthenticated" do
      get pages_path
      expect(response.status).to be(302)
    end
  end
end
