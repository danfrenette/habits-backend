class RecurrenceRule < ApplicationRecord
  belongs_to :task
  validates :rrule, presence: true

  DTSTART_REGEX = /DTSTART;TZID=([^:]+):([0-9T]+)/
  RRULE_REGEX = /RRULE:([^\n]+)/

  def dates(end_date: Time.current.end_of_month)
    rule.between(Time.current.beginning_of_day, end_date)
  end

  def time_zone
    rule.tz
  end

  private

  def rule
    raise RRule::InvalidRRule unless valid_rrule?

    @rule ||= RRule::Rule.new(rrule_match, dtstart: dtstart, tzid: tzid_match)
  end

  def valid_rrule?
    dtstart_match && rrule_match && tzid_match
  end

  def rrule_match
    @rrule_match ||= rrule.match(RRULE_REGEX).to_a.first
  end

  def dtstart
    Time.zone.strptime(dtstart_match, "%Y%m%dT%H%M%S").in_time_zone(tzid_match)
  end

  def dtstart_match
    @dtstart_match ||= rrule.match(DTSTART_REGEX).to_a.third
  end

  def tzid_match
    @tzid_match ||= rrule.match(DTSTART_REGEX).to_a.second
  end
end
