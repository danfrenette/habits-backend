require "rails_helper"

RSpec.describe RecurrenceRule, type: :model do
  subject(:recurrence_rule) { create(:recurrence_rule, rrule: rrule_string) }
  let(:rrule_string) { "DTSTART;TZID=America/New_York:20240603T035900\nRRULE:FREQ=DAILY" }

  describe "associations" do
    it { should belong_to(:task) }
  end

  describe "validations" do
    it { should validate_presence_of(:rrule) }
  end

  describe "#time_zone" do
    let(:rrule_string) { "DTSTART;TZID=America/New_York:20240603T035900\nRRULE:FREQ=DAILY" }

    it "returns the time zone of the rule" do
      expect(recurrence_rule.time_zone).to eq("America/New_York")
    end
  end

  describe "#dates" do
    context "when rrule is correctly formatted with DTSTART and RRULE" do
      let(:rrule_string) { "DTSTART;TZID=America/New_York:20240406T174209Z\nRRULE:FREQ=WEEKLY;INTERVAL=3;BYDAY=SU,MO,TU" }

      it "returns an array of dates" do
        Timecop.freeze(Time.new(2024, 4, 1).utc) do
          expect(recurrence_rule.dates).to eq([
            DateTime.new(2024, 4, 7, 13, 42, 9, "-04:00"),
            DateTime.new(2024, 4, 22, 13, 42, 9, "-04:00"),
            DateTime.new(2024, 4, 23, 13, 42, 9, "-04:00"),
            DateTime.new(2024, 4, 28, 13, 42, 9, "-04:00")
          ])
        end
      end
    end

    context "when rrule is missing DTSTART" do
      let(:rrule_string) { "RRULE:FREQ=DAILY;COUNT=10" }

      it "raises an error" do
        expect { recurrence_rule.dates }.to raise_error(RRule::InvalidRRule)
      end
    end

    context "when rrule is missing RRULE" do
      let(:rrule_string) { "DTSTART:20230101T000000Z" }

      it "raises an error" do
        expect { recurrence_rule.dates }.to raise_error(RRule::InvalidRRule)
      end
    end

    context "when rrule format leads to parsing errors" do
      let(:rrule_string) { "DTSTART:20230101T000000Z\nRRULE:INVALID_FORMAT" }

      it "raises an error from the RRule library" do
        expect { recurrence_rule.dates }.to raise_error(RRule::InvalidRRule)
      end
    end
  end
end
