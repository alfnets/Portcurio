# メインのサンプルユーザー1人目を作成する
User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)
  
# メインのサンプルユーザー2人目を作成する
User.create!(name:  "Example User2",
  email: "example2@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
   email: email,
   password:              password,
   password_confirmation: password,
   activated: true,
   activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
content = Faker::Lorem.sentence(word_count: 5)
users.each { |user| user.microposts.create!(content: content) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# 以下のいいねをする
users = User.order(:created_at).take(50)
micropost = Micropost.order(:created_at).first
users.each { |user| user.likes.create!(likeable: micropost) }
users = User.order(:created_at).take(5)
micropost = Micropost.order(:created_at).second
users.each { |user| user.likes.create!(likeable: micropost) }

# コメントをする
user  = users.first
micropost = Micropost.order(:created_at).first
3.times do
content = Faker::Lorem.sentence(word_count: 5)
micropost.comments.create!(content: content, user_id: user.id)
end
user  = users.second
micropost = Micropost.order(:created_at).second
3.times do
content = Faker::Lorem.sentence(word_count: 5)
micropost.comments.create!(content: content, user_id: user.id)
end