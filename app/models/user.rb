class User < ActiveRecord::Base
  has_secure_password
  has_many :messages
  has_many :user_conversations
  has_many :convesations, through: :user_conversations
  has_many :followers, foreign_key: :follower_id , class_name: "Friendship"
  has_many :followed, through: :followers
  has_many :followed, foreign_key: :followed_id, class_name: "Friendship"
  has_many :followers, through: :followed
end
