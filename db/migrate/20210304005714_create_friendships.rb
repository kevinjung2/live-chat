class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :follower_id
      y.integer :followed_id
      t.timestamps null: false
    end
  end
end
