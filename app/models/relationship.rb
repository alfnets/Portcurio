class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  # 規約: "モデル名_id" => follower_id <-> Follower    となるため、class_nameでUserクラスを指定
  belongs_to :followed, class_name: "User"
  # 規約: "モデル名_id" => Followed_id <-> Followed    となるため、class_nameでUserクラスを指定

  has_many :notifications, as: :notificable, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
