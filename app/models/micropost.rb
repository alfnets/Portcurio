class Micropost < ApplicationRecord
  belongs_to :user
  # Default: foreign_key: user_id <-> User
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :like_users,    through: :likes,    source: :user
  has_many :comments, dependent: :destroy
  has_many :comment_users, through: :comments, source: :user
  has_many :porcs,    dependent: :destroy 
  has_many :notifications, as: :notificable, dependent: :destroy
  has_many :micropost_tags, dependent: :destroy
  has_many :tags, through: :micropost_tags, dependent: :destroy
  
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

  attr_accessor :school_type, :string
  attr_accessor :subject, :string
                

  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :content_or_image_or_file_link, presence: true
  validates :content, length: { maximum: 280,
                                message: "should be less than 280 charactor" }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 10.megabytes,
                                      message: "should be less than 10MB" }
  validate  :valid_file_type, :valid_file_link
                                      
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [600, 600])
  end
  
  def tags_save(tag_list, user)
    tag_list.each do |tag|
      inspected_tag = Tag.where(name: tag).first_or_create
      self.micropost_tags.create(tag: inspected_tag, user: user, lock_flag: true)
    end
  end

  def tags_update(tag_list, user)
    unless self.user == user  # 投稿者ではない場合
      # lockされていないタグを全て削除
      micropost_free_tags_records = MicropostTag.where(micropost_id: self.id, lock_flag: false)
      micropost_free_tags_records.each do |micropost_tag|
        tag = micropost_tag.tag
        micropost_tag.destroy
        tag.destroy unless MicropostTag.exists?(tag_id: tag.id) || tag.default_flag # タグがMicropostTagで0かつデフォルトタグでもなかった場合はタグテーブルからも削除
      end
      # タグを登録
      tag_list.each do |tag|
        inspected_tag = Tag.where(name: tag).first_or_create
        self.micropost_tags.create(tag: inspected_tag, user: user, lock_flag: false)
      end
    else  # 投稿者の場合
      org_tags = self.tags.pluck(:name) # 既存のタグを取得
      # 既存のタグリストから新しいタグを比較
      tag_list.each do |new_tag|
        unless org_tags.include?(new_tag) # 既存のタグリストに新しいタグがなかった場合はそのタグを作成
          inspected_tag = Tag.where(name: new_tag).first_or_create
          self.micropost_tags.create(tag: inspected_tag, user: user, lock_flag: true)
        end
      end
      # 新しいタグリストから既存のタグを比較
      org_tags.each do |org_tag|
        unless tag_list.include?(org_tag) # 新しいタグリストに既存のタグがなかった場合はそのタグを削除
          tag = Tag.find_by(name: org_tag)
          self.micropost_tags.find_by(tag_id: tag.id).destroy
          tag.destroy unless MicropostTag.exists?(tag_id: tag.id) || tag.default_flag # タグがMicropostTagで0かつデフォルトタグでもなかった場合はタグテーブルからも削除
        end
      end
    end

  end
  
  private
    def content_or_image_or_file_link
      content.present? || image.present? || file_link.present?
    end

    def valid_file_type
      if file_type.present?
        valid_file_types = [ "GoogleSlides", "PowerPoint", "pdf_link", "pdf_google" ]
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
        elsif file_type == "pdf_link"
          check = file_link.html_safe.start_with?('https://') && \
                  file_link.html_safe.end_with?('.pdf')
        elsif file_type == "pdf_google"
          check = file_link.start_with?('https://drive.google.com/file/d/') && \
                  file_link.end_with?('/view?usp=sharing')
        end
        errors.add(:file_link, "Invalid file link") unless check
      end
    end
end
