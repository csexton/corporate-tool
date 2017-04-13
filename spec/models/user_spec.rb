require 'rails_helper'

RSpec.describe User, type: :model do

  let(:auth) {
    OpenStruct.new({
      provider: "google",
      uid: "1",
      info: OpenStruct.new({
        email: "amy@theponds.com",
        name: "Amy Pond",
      })
    })
  }

  describe "parsing omniauth hash" do
    it "creates a new user" do
      User.from_omniauth(auth)

      user = User.find_by! uid: "1"

      expect(user.email).to eq "amy@theponds.com"
    end

    it "updates email" do

      User.create(provider: "google", uid: "1", email: "amy@tardis.com")

      user = User.from_omniauth(auth)

      expect(user.email).to eq "amy@theponds.com"
    end
  end
end
