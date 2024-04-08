class RecurrenceRule < ApplicationRecord
  belongs_to :task
  validates :rrule, presence: true

  def dates
    rrule_match = rrule.match(/RRULE:(.*)/)
    return [] unless rrule_match && dtstart_time

    RRule.parse(rrule_match[0], dtstart: dtstart_time).between(Time.now, Time.now.end_of_month)
  end

  private

  def dtstart_time
    @dtstart_time ||= begin
      dtstart_match = rrule.match(/DTSTART:(\d{8}T\d{6}Z)/)
      return unless dtstart_match

      Time.strptime(dtstart_match[1], "%Y%m%dT%H%M%SZ").utc
    end
  end
end
