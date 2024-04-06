FactoryBot.define do
  factory :task_completion, aliases: [:completion] do
    task
    completed_at { Time.zone.now }
  end
end
