class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  has_many :notifications, as: :notificable, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  validates :user_id, {presence: true}
  validates :likeable_id, {presence: true}
  validates :likeable_type, {presence: true}
  
  # likeした投稿を取得する
  def micropost
    if likeable_type === 'Micropost'
      Micropost.find(self.likeable_id)
    elsif likeable_type === 'Comment'
      Micropost.find(self.likeable.micropost_id)
    end
  end
  
  # likeしたコメントを取得する（※ ポストのいいねに対して実行したらポストを取得する）
  def comment
    self.likeable
  end
  
end
