require "rails_helper"

RSpec.describe Tasks::CreateTaskCompletions, type: :service do
  subject { described_class.new(task) }

  let(:task) { create(:task, :recurring, :with_recurrence_rule, recurrence_ends_at: nil) }

  describe "#call" do
    context "when the task is recurring" do
      before do
        rrule_double = instance_double(RRule::Rule, between: [Date.current])
        allow(RRule).to receive(:parse).with(task.recurrence_rule.rrule).and_return(rrule_double)
      end

      it "creates a task completion for the given date" do
        expect { subject.call }.to change(TaskCompletion, :count).by(1)
        completion = TaskCompletion.last
        expect(completion).to have_attributes(
          task: task,
          due_at: Date.current # date of the task completion's recurrence
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
