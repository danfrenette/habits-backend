FactoryBot.define do
  factory :task do
    user
    recurring { false }
    sequence(:title) { |n| "Task #{n}" }
    status { :active }

    trait :recurring do
      recurring { true }
    end

    trait :non_recurring do
      recurring { false }
    end

    trait :completed do
      status { :completed }
    end

    trait :with_recurrence_rule do
      after(:create) do |task|
        create(:recurrence_rule, task: task)
      end
    end
  end
end
