FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    name { "Test User" }
    image { "https://robohash.org/my-own-slug.png" }
  end
end
