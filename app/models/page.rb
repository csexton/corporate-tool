class Page < ActiveRecord::Base
  validates_presence_of :body, :path
  validates_uniqueness_of :path
end
