class Page < ActiveRecord::Base
  validates_presence_of :body, :path
  validates_uniqueness_of :path
  has_paper_trail

  include PgSearch
  multisearchable against: [:title, :body, :path]

  pg_search_scope :search_for, against: [:path, :body]
end
