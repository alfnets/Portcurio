class Micropost < ApplicationRecord
  acts_as_taggable_on :tags
  acts_as_taggable_on :school_types, :subjects
  belongs_to :user
  # Default: foreign_key: user_id <-> User
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :like_users,    through: :likes,    source: :user
  has_many :comments, dependent: :destroy
  has_many :comment_users, through: :comments, source: :user
  has_many :porcs,    dependent: :destroy 
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
  validates :content_or_image_or_file_link, presence: true
  validates :content, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
  validate  :valid_file_type, :valid_file_link
                                      
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [600, 600])
  end
  
  
  private
    def content_or_image_or_file_link
      content.present? || image.present? || file_link.present?
    end

    def valid_file_type
      if file_type.present?
        valid_file_types = [ "GoogleSlides", "PowerPoint" ]
        unless valid_file_types.include?(file_type)
          errors.add(:file_type, "Invalid file type")
        end
      end
    end
  
    def valid_file_link
      if file_link.present?
        if file_type == "GoogleSlides"
          check = file_link.start_with?('<iframe src="https://docs.google.com/presentation/d/')
        elsif file_type == "PowerPoint"
          check = file_link.start_with?('<iframe src="https://onedrive.live.com/embed?resid=') && \
                  file_link.end_with?('これは、<a target="_blank" href="https://office.com/webapps">Office</a> の機能を利用した、<a target="_blank" href="https://office.com">Microsoft Office</a> の埋め込み型のプレゼンテーションです。</iframe>')
        end
        errors.add(:file_link, "Invalid file link") unless check
      end
    end
end
