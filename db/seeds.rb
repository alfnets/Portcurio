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

# デフォルトタグ
school_types = ["小学校", "中学校", "高校(共通)", "高校(専門)"]
school_types.each { |tag|
  Tag.create(name: tag, category: "school_type", default_flag: true)
}

subjects = ["国語", "社会", "算数", "理科", "生活", "音楽", "図画工作", "家庭", "体育", "外国語(英語)", "道徳", "総合", "特別活動", "学級活動"]
subjects.each { |tag|
  Tag.create(name: tag, category: "primary_subject", default_flag: true)
}

subjects = ["国語", "社会", "数学", "理科", "音楽", "美術", "保健体育", "技術", "家庭", "外国語(英語)", "道徳", "総合", "特別活動", "学級活動"]
subjects.each { |tag|
  b_tag = Tag.find_by(name: tag)
  if b_tag.present?
    if b_tag.category.present?
      category = b_tag.category + "," + "secondary_subject"
      b_tag.update(category: category)
    end
  else
    Tag.create(name: tag, category: "secondary_subject", default_flag: true)
  end
}

subjects = ["国語", "地理歴史", "公民", "数学", "理科", "保健体育", "芸術", "外国語(英語)", "家庭", "情報", "理数", "総合", "特別活動", "学級活動"]
subjects.each { |tag|
  b_tag = Tag.find_by(name: tag)
  if b_tag.present?
    if b_tag.category.present?
      category = b_tag.category + "," + "senior_common_subject"
      b_tag.update(category: category)
    end
  else
    Tag.create(name: tag, category: "senior_common_subject", default_flag: true)
  end
}

subjects = ["農業", "工業", "商業", "水産", "家庭", "看護", "情報", "福祉", "理数", "体育", "音楽", "美術", "英語"]
subjects.each { |tag|
  b_tag = Tag.find_by(name: tag)
  if b_tag.present?
    if b_tag.category.present?
      category = b_tag.category + "," + "senior_specialized_subject"
      b_tag.update(category: category)
    end
  else
    Tag.create(name: tag, category: "senior_specialized_subject", default_flag: true)
  end
}

tags = ["高等教育", "幼児教育", "特別支援"]
tags.each { |tag|
  Tag.create(name: tag, default_flag: true)
}

# 添付できるファイルの種類
file_categories = ["Google", "Microsoft", "LoiLo", "PDF"]
file_categories.each { |file_category|
  FileCategory.create(name: file_category)
}
file_types = [
  {name: "Google スライド",         value: "GoogleSlides",  file_category_id: 1},
  {name: "Google ドキュメント",     value: "GoogleDocs",    file_category_id: 1},
  {name: "Google スプレッドシート", value: "GoogleSheets",  file_category_id: 1},
  {name: "Google フォーム",         value: "GoogleForms",   file_category_id: 1},
  {name: "PowerPoint",              value: "PowerPoint",    file_category_id: 2},
  {name: "PDFリンク",               value: "PDF_link",      file_category_id: 4},
  {name: "Google PDF",              value: "GooglePDF",     file_category_id: 4}
]
file_types.each do |file_type|
  FileType.create!(name: file_type[:name],
                  value: file_type[:value],
       file_category_id: file_type[:file_category_id])
end