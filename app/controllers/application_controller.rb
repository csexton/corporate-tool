class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Sessions older than this require signing in with Google again, so access
  # ends for people removed from the Google domain.
  SESSION_MAX_AGE = 2.weeks

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = user_from_session
  end
  helper_method :current_user

  def user_from_session
    return unless session[:user_id]

    signed_in_at = session[:signed_in_at]
    if signed_in_at.nil? || Time.zone.at(signed_in_at) < SESSION_MAX_AGE.ago
      reset_session
      return
    end

    User.find_by(id: session[:user_id])
  end

  def sign_in_user(user)
    reset_session
    session[:user_id] = user.id
    session[:signed_in_at] = Time.current.to_i
  end


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
