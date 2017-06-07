class SearchController < ApplicationController
  def show
    @query = params[:q]

    if @query
      @results = PgSearch.multisearch(@query)

      case params[:t]
      when "Page"
        @results = @results.where(searchable_type: "Page")
      when "Gist"
        @results = @results.where(searchable_type: ["Gist", "GistFile"])
      end
    end
  end

end
