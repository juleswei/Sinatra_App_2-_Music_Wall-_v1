class AddSongs < ActiveRecord::Migration
  
  def change
    create_table :songs do |t|
      t.references :user
      t.string :title
      t.string :artist
      t.string :url
      t.date :created_at
      t.date :updated_at
    end
  end
end
