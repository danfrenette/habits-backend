FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    name { "Test User" }
    image { "https://robohash.org/my-own-slug.png" }
    sequence(:clerk_id) { |n| "clerk-#{n}" }
  end
end
