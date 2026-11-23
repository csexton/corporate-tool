class SessionsController < ApplicationController
  before_action :require_homedomain, only: :create

  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_user(user)
    url = request.env['omniauth.origin'] || root_url
    url = root_url if url.ends_with? welcome_auth_path
    redirect_to url, notice: "Signed in."
  end

  def destroy
    reset_session
    redirect_to welcome_auth_path, notice: "Signed out."
  end

  def failure
    render text: "Sorry, but you didn't allow access to our app!"
  end

  private

  def require_homedomain
    if ENV['GOOGLE_HOME_DOMAIN']
      unless request.env['omniauth.auth']['extra']['raw_info']['hd'] == ENV['GOOGLE_HOME_DOMAIN']
        redirect_to welcome_auth_path, notice: "Invalid Google Apps Domain"
      end
    end
  end

end
