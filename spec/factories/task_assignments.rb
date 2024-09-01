FactoryBot.define do
  factory :task_assignment, aliases: [:assignment] do
    task
    due_at { Time.zone.now }

    trait :completed do
      completed_at { Time.zone.now }
    end
  end
end
