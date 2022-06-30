FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "Test Comment #{n}" }
    association :user, :micropost
  end
end
