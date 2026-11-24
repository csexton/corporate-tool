require 'rails_helper'

RSpec.describe "Search", type: :request do
  let(:rory) { User.create!(name: "Rory Williams", uid: "1") }

  it "redirects to sign in when unauthenticated" do
    get search_path(q: "blink")

    expect(response).to redirect_to(welcome_auth_path(origin: "/search?q=blink"))
  end

  it "returns matching pages when signed in" do
    sign_in rory
    Page.create!(path: "weeping-angels", body: "Don't blink. Don't even blink.")

    get search_path(q: "blink")

    expect(response).to be_successful
    expect(response.body).to include("/weeping-angels")
  end
end
