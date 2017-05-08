class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    if current_user.update(user_params)
      redirect_to helpers.profile_path, notice: "user was successfully updated."
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone_number, :slack_username, :github_username)
  end

end
