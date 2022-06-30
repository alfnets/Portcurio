class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many   :likes, as: :likeable, dependent: :destroy
  has_many   :like_users, through: :likes, source: :user
  has_many   :notifications, as: :notificable, dependent: :destroy
  
  has_many :replies, class_name: "Comment",
                    foreign_key: "parent_id", dependent: :destroy
  
  belongs_to :parent, class_name: "Comment", optional: true
  
  default_scope -> { order(created_at: :desc) }
  
  serialize :mention_users, Array
  
  validates :content,        presence: true, length: { maximum: 140 }
  validates :micropost_id,   presence: true
  validates :user_id,        presence: true
end
