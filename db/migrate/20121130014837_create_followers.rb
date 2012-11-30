class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followes do |t|
      t.string :username
      t.text :profile_picture
      t.string :state
      t.integer :user_id
      t.datetime :last_change

      t.timestamps
    end
  end
end
