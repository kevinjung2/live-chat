class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.timestamps null: false
    end
  end
end
