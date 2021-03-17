class User < ActiveRecord::Base
  has_secure_password
  has_many :messages
  has_many :user_conversations
  has_many :conversations, through: :user_conversations
  #self join table makes it so users can be assossiated with other users
  #sets the method for setting and retrieving a users followers from the friendship join table to the follower_id foreign key in the friendship table.
  #does the same for a users "followed" users with the followed_id foreign key.
  has_many :followers, foreign_key: :follower_id , class_name: "Friendship"
  has_many :followed, through: :followers
  has_many :followed, foreign_key: :followed_id, class_name: "Friendship"
  has_many :followers, through: :followed
end
