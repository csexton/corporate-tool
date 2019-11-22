class SearchController < ApplicationController
  def show
    @query = params[:q]

    if @query
      @results = PgSearch.multisearch(@query)
    end
  end

end
