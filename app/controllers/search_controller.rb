class SearchController < ApplicationController
  before_action :authenticate_user!

  def show
    @query = params[:q]

    if @query
      @results = PgSearch.multisearch(@query)
    end
  end

end
