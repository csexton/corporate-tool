require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET 'auth'" do
    it "returns http success" do
      get 'auth', {}, { user_id: nil}
      expect(response).to be_success
    end
  end

end
