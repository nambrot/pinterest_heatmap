class AddPreviousBookmarkToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :previous_bookmark, :string
  end
end
