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
        rrule_instance = instance_double(RRule::Rule, between: true)
        allow(RRule).to receive(:parse)
          .with(
            "RRULE:FREQ=WEEKLY;INTERVAL=3;BYDAY=SU,MO,TU",
            dtstart: Time.new(2024, 4, 6, 17, 42, 9).utc
          )
          .and_return(rrule_instance)

        Timecop.freeze(Time.new(2024, 4, 1).utc) do
          expect(recurrence_rule.dates).to eq(true)
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
