require "rails_helper"

RSpec.describe Tasks::CreateTaskCompletions, type: :service do
  subject { described_class.new(task) }

  let(:task) { create(:task, :recurring, :with_recurrence_rule, recurrence_ends_at: nil) }

  describe "#call" do
    context "when the task is recurring" do
      it "creates a task completion for the given date" do
        expect { subject.call }.to change(TaskCompletion, :count).by(1)

        completion = TaskCompletion.last

        expect(completion).to have_attributes(
          task: task,
          due_at: be_within(1.second).of(Date.current.end_of_day)
        )
      end
    end

    context "when the task is not recurring" do
      let(:task) { create(:task, :non_recurring) }

      it "raises an error" do
        expect { subject.call }.to raise_error(Tasks::CreateTaskCompletions::TaskNotRecurringError)
      end
    end
  end
end
