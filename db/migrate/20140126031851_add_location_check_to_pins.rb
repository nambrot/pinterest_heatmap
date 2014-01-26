class AddLocationCheckToPins < ActiveRecord::Migration
  def change
    add_column :pins, :location_check, :boolean
  end
end
