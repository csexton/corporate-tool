class Gist < ActiveRecord::Base
  belongs_to :user
  has_many :gist_files
  accepts_nested_attributes_for :gist_files
  validates_presence_of :description

  def user_name
    user&.name || "Nobody"
  end
end
