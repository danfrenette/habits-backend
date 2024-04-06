require "rails_helper"

RSpec.describe RecurrenceRule, type: :model do
  describe "associations" do
    it { should belong_to(:task) }
  end

  describe "validations" do
    it { should validate_presence_of(:rrule) }
  end

  describe "#dates" do
    let(:recurrence_rule) { create(:recurrence_rule, rrule: rrule_string) }

    context "when rrule is correctly formatted with DTSTART and RRULE" do
      let(:rrule_string) { "DTSTART:20240406T174209Z\nRRULE:FREQ=WEEKLY;INTERVAL=3;BYDAY=SU,MO,TU" }

      it "returns an array of dates" do
        Timecop.freeze(Time.new(2024, 4, 1)) do
          expect(recurrence_rule.dates).to eq([
            Time.utc(2024, 4, 7, 21, 42, 9),
            Time.utc(2024, 4, 22, 21, 42, 9),
            Time.utc(2024, 4, 23, 21, 42, 9),
            Time.utc(2024, 4, 28, 21, 42, 9)
          ])
        end
      end
    end

    context "when rrule is missing DTSTART" do
      let(:rrule_string) { "RRULE:FREQ=DAILY;COUNT=10" }

      it "returns an empty array" do
        expect(recurrence_rule.dates).to eq([])
      end
    end

    context "when rrule is missing RRULE" do
      let(:rrule_string) { "DTSTART:20230101T000000Z" }

      it "returns an empty array" do
        expect(recurrence_rule.dates).to eq([])
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
