require 'rails_helper'

RSpec.describe User, type: :model do
  describe "parsing omniauth hash" do
    it "creates a new user" do
      auth = {
        "provider" => "google",
        "uid" => "1",
        "info" => {
          "email" => "amy@theponds.com",
          "name" => "Amy Pond",
        }
      }

      User.from_omniauth(auth)

      user = User.find_by! uid: "1"

      expect(user.email).to eq "amy@theponds.com"
    end

    it "updates email" do
      auth = {
        "provider" => "google",
        "uid" => "1",
        "info" => {
          "email" => "amy@theponds.com",
          "name" => "Amy Pond",
        }
      }

      User.create(provider: "google", uid: "1", email: "amy@tardis.com")

      user = User.from_omniauth(auth)

      expect(user.email).to eq "amy@theponds.com"
    end
  end
end
