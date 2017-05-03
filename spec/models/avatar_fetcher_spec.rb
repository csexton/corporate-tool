require 'rails_helper'

RSpec.describe AvatarFetcher, type: :model do

  it "returns false when the request fails" do
    user = double(User, provider: "google")
    fetcher = AvatarFetcher.new(user)
    expect(fetcher.run).to eq "yay"
  end

  it "returns false when the response body doesn't have a image.url key"

  it "sets the url after #run"
end
