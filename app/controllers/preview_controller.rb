class PreviewController < ApplicationController
  before_action :authenticate_user!

  def show
    body = Renderer.markdown(params[:body])
    render plain: body, layout: false
  end
end
