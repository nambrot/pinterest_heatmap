class Bookmark < ActiveRecord::Base

  validates :bookmark, :presence => true
end
