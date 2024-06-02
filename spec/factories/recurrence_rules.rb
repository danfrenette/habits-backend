FactoryBot.define do
  factory :recurrence_rule do
    task
    rrule { "DTSTART:20240526T182200Z\nRRULE:FREQ=DAILY;INTERVAL=1" }
  end
end
