FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "Test Micropost #{n}" }
    association :user

    # コメント付きのマイクロポスト
    # trait :with_comments do
    #   after(:create) { |micropost| create_list(:comment, 5, micropost: micropost) }
    # end
  end
end

# def user_with_posts(posts_count: 5)
#   FactoryBot.create(:user) do |user|
#     FactoryBot.create_list(:micropost, posts_count, user: user)
#   end
# end