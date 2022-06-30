FactoryBot.define do
  factory :user , aliases: [:followed, :follower] do
    sequence(:name)       { |n| "Example User #{n}" }
    sequence(:email)      { |n| "tester#{n}@example.com" }
    password              { "dottle-nouveau-pavilion-tights-furze" }
    password_confirmation { "dottle-nouveau-pavilion-tights-furze" }

    trait :activated do
      activated    { true }
      activated_at { Time.zone.now }
    end

    trait :admin do
      activated    { true }
      activated_at { Time.zone.now }
      admin        { true }
    end

    trait :with_posts do
      activated    { true }
      activated_at { Time.zone.now }
      after(:create) { |user| create_list(:micropost, 31, user: user) }
    end
  end

  factory :mob_users, class: 'User' do
    name                  { Faker::Name.unique.name } 
    email                 { Faker::Internet.unique.free_email }
    password              { "mob-nouveau-pavilion-tights-furze" }
    password_confirmation { "mob-nouveau-pavilion-tights-furze" }

    trait :activated do
      activated    { true }
      activated_at { Time.zone.now }
    end
  end

  factory :other_user, class: 'User' do
    name                  { "Example Other User" }
    sequence(:email)      { |n| "tester_other#{n}@example.com" }
    password              { "other-nouveau-pavilion-tights-furze" }
    password_confirmation { "other-nouveau-pavilion-tights-furze" }

    trait :activated do
      activated    { true }
      activated_at { Time.zone.now }
    end
  end

  factory :invalid_user, class: 'User' do
    name                  { "" }
    sequence(:email)      { "invalidtester@example" }
    password              { "short" }
    password_confirmation { "rack" }
  end
end


def create_relationships
  FactoryBot.create_list(:mob_users, 10, :activated)
 
  FactoryBot.create(:user, :activated) do |user|
    User.all[0...-1].each do |other|
      FactoryBot.create(:relationship, follower: other, followed: user)
      FactoryBot.create(:relationship, follower: user, followed: other)
    end
    user
  end
end