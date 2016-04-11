class AddUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string :name
        t.string :email
        t.string :password
        t.date :created_at
        t.date :updated_at
      end
  end
end
