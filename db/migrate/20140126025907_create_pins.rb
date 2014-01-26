class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :uid
      t.text :data

      t.timestamps
    end

    add_index :pins, :uid, :unique => true
  end
end
