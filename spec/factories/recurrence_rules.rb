FactoryBot.define do
  factory :recurrence_rule do
    task
    rrule { "DTSTART;TZID=America/New_York:#{Time.current.strftime("%Y%m%dT%H%M%S")}\nRRULE:FREQ=DAILY" }
  end
end
