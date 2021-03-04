class CreateUserConversations < ActiveRecord::Migration
  def change
    create_table :user_conversations do |t|

      t.timestamps null: false
    end
  end
end
