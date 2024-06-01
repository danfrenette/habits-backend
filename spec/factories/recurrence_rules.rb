FactoryBot.define do
  factory :recurrence_rule do
    task
    rrule { "RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=SU,MO,TU" }
  end
end
