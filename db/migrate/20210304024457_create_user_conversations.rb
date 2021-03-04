class CreateUserConversations < ActiveRecord::Migration
  def change
    create_table :user_conversations do |t|
      t.integer :follwer_id
      t.integer :followed_id
      t.timestamps null: false
    end
  end
end
