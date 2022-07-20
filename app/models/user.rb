class User < ApplicationRecord
  has_many :microposts,       dependent: :destroy
  has_many :likes,            dependent: :destroy
  has_many :like_microposts,    through: :likes,
                                 source: :likeable,
                            source_type: 'Micropost'
  has_many :like_comments,      through: :likes,
                                 source: :likeable,
                            source_type: 'Comment'
  has_many :comments,         dependent: :destroy
  has_many :comment_microposts, through: :comments,
                                 source: :micropost
  has_many :porcs,            dependent: :destroy                              
                                 
  # Default: class_name: "Micropost"
  # Default: foreign_key: "user_id"
  # => "#{Model Name}s"
  has_many :active_relationships,   class_name: "Relationship",
                                   foreign_key: "follower_id",
                                     dependent: :destroy
  has_many :passive_relationships,  class_name: "Relationship",
                                   foreign_key: "followed_id",
                                     dependent: :destroy
  has_many :following,  through: :active_relationships,
                         source: :followed
  has_many :followers,  through: :passive_relationships,
                         source: :follower
  # => ActiveRelationship model (class)
  # class => Relationship

  has_many :subscribe_active_relationships, -> {where(subscribed: true)},
                                    class_name: "Relationship",
                                   foreign_key: "follower_id",
                                     dependent: :destroy
  has_many :subscribing, through: :subscribe_active_relationships,
                          source: :followed
  
  has_many :subscribe_passive_relationships, -> {where(subscribed: true)},
                                    class_name: "Relationship",
                                   foreign_key: "followed_id",
                                     dependent: :destroy
  has_many :subscribers, through: :subscribe_passive_relationships,
                          source: :follower
                          
  has_many :active_notifications,    class_name: "Notification",
                                    foreign_key: "notifier_id",
                                      dependent: :destroy
  has_many :passive_notifications,   class_name: "Notification",
                                    foreign_key: "notified_id",
                                      dependent: :destroy
                                      
  has_many :notifying, through: :active_notifications,
                        source: :notified
  has_many :notifiers, through: :passive_notifications,
                        source: :notifier
                         
  has_many :notifying_relationships, through: :active_notifications,
                                      source: :notificable,
                                 source_type: 'Relationship'
  has_many :notifyer_relationships,  through: :passive_notifications,
                                      source: :notificable,
                                 source_type: 'Relationship'
  has_many :notifying_likes,      through: :active_notifications,
                                   source: :notificable,
                              source_type: 'Like'
  has_many :notifyer_likes,       through: :passive_notifications,
                                   source: :notificable,
                              source_type: 'Like'
  has_many :notifying_microposts, through: :active_notifications,
                                   source: :notificable,
                              source_type: 'Micropost'
  has_many :notifyer_microposts,  through: :passive_notifications,
                                   source: :notificable,
                              source_type: 'Micropost'
  has_many :notifying_comments,   through: :active_notifications,
                                   source: :notificable,
                              source_type: 'Comment'
  has_many :notifyer_comments,    through: :passive_notifications,
                                   source: :notificable,
                              source_type: 'Comment'
  
  attr_accessor :remember_token,
                :activation_token,
                :reset_token,
                :delete_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  validates :name,  presence: true,
                      length: { in: 3..50 }                      
                      # length: { maximum: 50 }
                      # uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                      length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      # uniqueness: { case_sensitive: false } before_saveですべて小文字に変換しているため不要
                      uniqueness: true
                      
  has_secure_password
  
  validates :password, presence: true, 
                         length: { minimum: 6 },
                      allow_nil: true

  attr_encrypted :lineuid, key: 'This is a key that is 256 bits!!'
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    self.update_attribute(:activated,     true)
    self.update_attribute(:activated_at,  Time.zone.now)
  end

  # 有効化トークンとダイジェストを再作成および更新する
  def reset_activation_digest
    self.activation_token  = User.new_token
    update_attribute(:activation_digest, User.digest(activation_token))
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # アカウント削除の属性を設定する
  def create_delete_digest
    self.delete_token = User.new_token
    update_attribute(:delete_digest, User.digest(delete_token))
  end

  # アカウントの削除メールを送信する
  def send_delete_email
    UserMailer.account_delete(self).deliver_now
  end

  # アカウントの削除が完了したメールを送信する
  def send_delete_comp_email
    UserMailer.account_delete_comp(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end
  
  # ユーザーのステータスフィードを返す
  def feed
    # 試作feedの定義
    # Micropost.where("user_id = ?", self.id)
    
    # 完全な実装は次章の「ユーザーをフォローする」を参照
    # following と where で２回の問い合わせが走ってしまう
    # Micropost.where("user_id IN (?) OR user_id = ?",
    #                       following_ids,      self.id)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                     following_ids: following_ids, user_id: self.id)
    # 相関副問合せで一回の問い合わせで済むようにしている
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                    user_id: self.id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    self.following << other_user
  end
  
  # ユーザーをフォロー解除する
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしていたらtrueを返す
  def following?(other_user)
    self.following.include?(other_user)
  end
  
  # 現在のユーザーがお気に入りに登録する
  def subscribe(other_user)
    relationship = self.active_relationships.find_by(followed_id: other_user.id)
    relationship.update_attribute(:subscribed, true)
  end

  # 現在のユーザーがお気に入りから外す
  def unsubscribe(other_user)
    relationship = self.active_relationships.find_by(followed_id: other_user.id)
    relationship.update_attribute(:subscribed, false)
  end
  
  # 現在のユーザーがお気に入り登録していたらtrueを返す
  def subscribing?(other_user)
    relationship = self.active_relationships.find_by(followed_id: other_user.id)
    relationship.present? && relationship.subscribed?
  end
  
  
  private
  
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end