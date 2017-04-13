class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: 'auth'
  def index
    @page = Page.find_by path: 'index'
    render 'pages/show' if @page
  end

  def auth
    render layout: nil
  end
end
