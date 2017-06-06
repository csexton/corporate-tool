class GistFile < ActiveRecord::Base
  belongs_to :gist

  include PgSearch
  multisearchable against: [:body, :file_name]
end
