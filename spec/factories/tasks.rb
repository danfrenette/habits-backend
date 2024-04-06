FactoryBot.define do
  factory :task do
    user
    recurring { false }
    sequence(:title) { |n| "Task #{n}" }
    status { :active }

    trait :recurring do
      recurring { true }
      after(:create) do |task|
        create(:recurrence_rule, task: task)
      end
    end
  end
end
