class Micropost < ApplicationRecord
  belongs_to :user
  # Default: foreign_key: user_id <-> User
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :like_users,    through: :likes,    source: :user
  has_many :comments, dependent: :destroy
  has_many :comment_users, through: :comments, source: :user
  has_many :notifications, as: :notificable, dependent: :destroy
  
  # ポリモーフィックと外部キーでの関連付けはカスタマイズしないとできない
  # has_many :active_notifications,            as: :notificable,
  #                                   class_name: "Notification",
  #                                   foreign_key: "notifier_id",
  #                                     dependent: :destroy
  # has_many :passive_notifications,           as: :notificable,
  #                                   class_name: "Notification",
  #                                   foreign_key: "notified_id",
  #                                     dependent: :destroy

  # has_many :notifying,     through: :active_notifications,
  #                           source: :notificable,
  #                     source_type: 'User'
  # has_many :notifiers,     through: :passive_notifications,
  #                           source: :notificable,
  #                     source_type: 'User'

  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :content_or_image, presence: true
  validates :content, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
                                      
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [600, 600])
  end
  
  
  private
    def content_or_image
      content.present? || image.present?
    end
  
end
