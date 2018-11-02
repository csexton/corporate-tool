class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user


  def user_signed_in?
    if current_user
      true
    else
      false
    end
  end


  def authenticate_user!
    unless user_signed_in?
      if request.format == :json
        render json: {error: '401 Unauthorized'}, status: :unauthorized
      else
        if request.fullpath
          redirect_to welcome_auth_path(origin: request.fullpath)
        else
          redirect_to root_url
        end
      end
    end
  end

end
