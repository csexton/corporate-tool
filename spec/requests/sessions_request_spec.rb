require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  include ActiveSupport::Testing::TimeHelpers

  around do |example|
    home_domain = ENV["GOOGLE_HOME_DOMAIN"]
    ENV["GOOGLE_HOME_DOMAIN"] = "tardis.org"
    example.run
  ensure
    ENV["GOOGLE_HOME_DOMAIN"] = home_domain
  end

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
      provider: "google", uid: "1",
      info: { name: "Amy Pond", email: "amy@tardis.org" },
      extra: { raw_info: { hd: "tardis.org" } }
    )
  end

  after do
    OmniAuth.config.mock_auth[:google] = nil
  end

  def sign_in_with_google
    get "/auth/google/callback",
        env: { "omniauth.auth" => OmniAuth.config.mock_auth[:google] }
  end

  it "keeps a fresh session signed in" do
    sign_in_with_google

    get pages_path

    expect(response).to be_successful
  end

  it "requires signing in again once the session is older than the max age" do
    sign_in_with_google

    travel ApplicationController::SESSION_MAX_AGE + 1.minute do
      get pages_path
    end

    expect(response).to redirect_to(welcome_auth_path(origin: "/pages"))
  end

  it "does not extend the max age for active users" do
    sign_in_with_google

    travel 1.week do
      get pages_path
      expect(response).to be_successful
    end
    travel ApplicationController::SESSION_MAX_AGE + 1.minute do
      get pages_path
    end

    expect(response).to redirect_to(welcome_auth_path(origin: "/pages"))
  end

  it "clears the session on sign out" do
    sign_in_with_google

    get signout_path
    get pages_path

    expect(response).to redirect_to(welcome_auth_path(origin: "/pages"))
  end

  it "filters page bodies from the logs" do
    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    filtered = filter.filter("page" => { "path" => "unit/black-archive", "body" => "Door code: bad wolf" })

    expect(filtered["page"]).to eq("path" => "unit/black-archive", "body" => "[FILTERED]")
  end
end
