FactoryBot.define do
  factory :recurrence_rule do
    task
    rrule { "MyString" }
  end
end
