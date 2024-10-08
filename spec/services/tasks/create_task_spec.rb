require "rails_helper"

RSpec.describe Tasks::CreateTask do
  describe ".call" do
    context "when creating a non-recurring task" do
      it "creates a task" do
        user = create(:user)
        params = build_params(clerk_id: user.clerk_id)
        expect { described_class.call(params) }.to change { Task.count }.by(1)

        task = Task.last
        expect(task).to have_attributes(
          title: "Test Task",
          user: user,
          recurring: false,
          slug: "test-task"
        )
      end
    end

    context "when creating a recurring task" do
      it "creates a task and a recurrence rule" do
        user = create(:user)
        params = build_params(clerk_id: user.clerk_id, recurring: true, rrule: "FREQ=DAILY")

        expect { described_class.call(params) }
          .to change { Task.count }.by(1)
          .and change { RecurrenceRule.count }.by(1)

        task = Task.last
        recurrence_rule = RecurrenceRule.last

        expect(task).to have_attributes(
          title: "Test Task",
          user: user,
          recurring: true,
          slug: "test-task"
        )
        expect(recurrence_rule).to have_attributes(rrule: "FREQ=DAILY")
      end
    end

    context "when the user does not exist" do
      it "handles the error" do
        allow(User).to receive(:find_in_clerk).and_raise(ActiveRecord::RecordNotFound)
        params = {clerk_id: "not a real ID", title: "Test Task", recurring: false}

        expect { described_class.call(params) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def build_params(overrides = {})
    {
      recurring: "false",
      title: "Test Task"
    }.merge(overrides)
  end
end
