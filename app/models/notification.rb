class Notification < ApplicationRecord
  belongs_to :notifier, class_name: "User"
  belongs_to :notified, class_name: "User"
  belongs_to :notificable, polymorphic: true  # micropost, comment, like, relationship
  
  default_scope -> { order(created_at: :desc) }
  
  validates :notifier_id, {presence: true}
  validates :notified_id, {presence: true}
  validates :notificable_id, {presence: true}
  validates :notificable_type, {presence: true}
  
  # 確認済みにする
  def check
    self.update_attribute(:checked, true)
  end
  
end
