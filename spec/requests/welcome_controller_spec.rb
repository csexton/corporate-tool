require 'rails_helper'

RSpec.describe "Welcome", :type => :request do

  describe "GET 'auth'" do
    it "returns http success" do
      get welcome_auth_path
      expect(response).to be_successful
    end
  end

end
