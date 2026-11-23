require 'rails_helper'

RSpec.describe "Search", type: :request do
  let(:rory) { User.create!(name: "Rory", uid: "1") }

  it "redirects to sign in when unauthenticated" do
    get search_path(q: "query")

    expect(response).to redirect_to(welcome_auth_path(origin: "/search?q=query"))
  end

  it "returns matching pages when signed in" do
    sign_in rory
    Page.create!(path: "sql", body: "How to write a query")

    get search_path(q: "query")

    expect(response).to be_successful
    expect(response.body).to include("/sql")
  end
end
