FactoryBot.define do
  factory :habit do
    user
    sequence(:name) { |n| "Habit #{n}" }
    current { false }
  end
end
