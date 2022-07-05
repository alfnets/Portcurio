require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)       { FactoryBot.build(:user) }
  let(:other_user) { FactoryBot.build(:user) }
  let(:third_user) { FactoryBot.build(:user) }

  # 属性テスト
  context "attributes" do
    # 名前、メール、パスワードがあれば有効な状態であること
    it "is valid with name, email, and password" do
      expect(user).to be_valid
    end

    # 名前がなければ無効な状態であること
    it "is invalid without a name" do
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    # 名前が空白であれば無効な状態であること
    it "is invalid with a blank name" do
      user.name = "     "
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    # 名前が短過ぎであれば無効な状態であること
    it "is invalid with a too short name" do
      user.name = "a" * 2
      user.valid?
      expect(user.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    # 名前が長過ぎであれば無効な状態であること
    it "is invalid with a too long name" do
      user.name = "a" * 51
      user.valid?
      expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end

    # メールアドレスがなければ無効な状態であること
    it "is invalid without an email address" do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    # メールアドレスが空白であれば無効な状態であること
    it "is invalid with a blank email address" do
      user.email = "     "
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    # メールアドレスが長過ぎであれば無効な状態であること
    it "is invalid with a too long email address" do
      user.email = ("a" * 244) + "@example.com"
      user.valid?
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end

    # 重複したメールアドレスなら無効な状態であること
    it "is invalid with a duplicate email address" do
      user.email       = "aaron@example.com"
      user.save
      other_user.email = "aaron@example.com"
      other_user.valid?
      expect(other_user.errors[:email]).to include("has already been taken")
    end

    # 正しいメールアドレスなら有効な状態であること
    it "is valid with a correct email address" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    # 正しくないメールアドレスなら無効な状態であること
    it "is invalid with a incorrect email address" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    # 空のパスワードなら無効な状態であること
    it "is invalid with a blank password" do
      user.password = " " * 6
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    # 6文字未満のパスワードなら無効な状態であること
    it "is invalid with a minimum length" do
      user.password = "a" * 5
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    # 認証ダイジェスト確認メソッド（ダイジェストがnilなら無効な状態であること）
    it "is invalid with a nil digest by 'authenticated?'" do
      expect(user.authenticated?(:remember ,'')).to be_falsy
    end

    # 認証ダイジェストが有効な場合のテストはシステムテストに記述する
  end


  context "associations" do
    # ユーザーを削除したらユーザーのマイクロポストも削除されること
    it "is associated its microposts (delete)" do
      user.save
      user.microposts.create!(content: "Lorem ipsum")
      expect {
        user.destroy
      }.to change(user.microposts, :count).by(-1)
    end

    # ユーザーを削除したらユーザーの like も削除されること
    it "is associated its likes (delete)" do
      user.save
      micropost = user.microposts.create!(content: "Lorem ipsum")
      user.likes.create!(likeable: micropost)
      expect {
        user.destroy
      }.to change(user.likes, :count).by(-1)
    end

    # ユーザーを削除したらユーザーのコメントも削除されること
    it "is associated its comments (delete)" do
      user.save
      micropost = user.microposts.create!(content: "Lorem ipsum")
      micropost.comments.create!(content: "Lorem ipsum", user: user)
      expect {
        user.destroy
      }.to change(user.comments, :count).by(-1)
    end

    # 中間テーブルの確認（like したら ユーザーが like した マイクロポストの一覧を表示できること）
    it "is associated its microposts via likes" do
      user.save
      other_user.save
      micropost = FactoryBot.create(:micropost, user: user) 
      aggregate_failures do
        expect {
          micropost.likes.create!(user: other_user)
        }.to change(other_user.like_microposts, :count).by(1)
        expect(micropost).to eq other_user.like_microposts.first
      end
    end

    # 中間テーブルの確認（like したら ユーザーが like した コメントの一覧を表示できること）
    it "is associated its comments via likes" do
      user.save
      other_user.save
      micropost = FactoryBot.create(:micropost, user: user) 
      comment   = FactoryBot.create(:comment, micropost: micropost, user: user)
      aggregate_failures do
        expect {
          comment.likes.create!(user: other_user)
        }.to change(other_user.like_comments, :count).by(1)
        expect(comment).to eq other_user.like_comments.first
      end
    end
  end


  context "methods" do
    # フォローメソッド関連の確認
    it "has follow and following method" do
      user.save
      other_user.save
      expect(user.following?(other_user)).to be_falsy # 元々はフォローしていない
      
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy # フォローできた
      expect(other_user.followers.include?(user)).to be_truthy # フォロワーに登録された

      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsy # フォロー解除できた
      expect(other_user.followers.include?(user)).to be_falsy # フォロワーから削除された
    end

    # feedには自分とフォローしているユーザーの投稿しか含まれないこと
    it "has feed method" do
      user.save
      other_user.save
      third_user.save

      user.microposts.create!(content: "Lorem ipsum")
      other_user.microposts.create!(content: "Lorem ipsum")
      third_user.microposts.create!(content: "Lorem ipsum")

      user.follow(third_user)

      # 自分自身の投稿を見れること
      user.microposts.each do |post_self|
        expect(user.feed).to be_include(post_self)
      end
      
      # フォローしているユーザーの投稿を見れること
      third_user.microposts.each do |post_following|
        expect(user.feed).to be_include(post_following)
      end

      # フォローしていないユーザーの投稿を見れないこと
      other_user.microposts.each do |post_unfollowed|
        expect(user.feed.include?(post_unfollowed)).to be_falsy
      end
    end

    it "has authenticated method" do
      user.save
      expect(user.authenticated?("remember","hoge")).to be_falsy
    end

    it "has reset_activation_digest method" do
      user.activation_token  = User.new_token
      user.activation_digest = User.digest(user.activation_token)
      user.save
      activation_token1  = user.activation_token
      activation_digest1 = user.activation_digest
      user.reset_activation_digest
      aggregate_failures do
        expect(user.activation_token).to_not eq activation_token1
        expect(user.activation_digest).to_not eq activation_digest1
      end
    end
  end
end
