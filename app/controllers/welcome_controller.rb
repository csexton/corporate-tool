class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: 'auth'
  def index
    @page = Page.find_by path: 'index'
    render 'pages/show' if @page
  end

  def auth
    @query = { origin: params[:origin] }.to_query if params[:origin]
    render layout: nil
  end
end
