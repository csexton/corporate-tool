class DirectoryController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.order(:name)
  end

  def show
    @user = User.find(params[:id])
  end

end
