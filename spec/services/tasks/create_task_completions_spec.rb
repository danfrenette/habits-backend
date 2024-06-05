require "rails_helper"

RSpec.describe Tasks::CreateTaskCompletions, type: :service do
  subject { described_class.new(task) }

  let(:task) { create(:task, :recurring, :with_recurrence_rule, recurrence_ends_at: nil) }
  let(:rule) { task.recurrence_rule }

  describe "#call" do
    context "when the task is recurring" do
      it "creates a task completion for the given date" do
        expect { subject.call }.to change(TaskCompletion, :count).by(1)

        completion = TaskCompletion.last

        expect(completion.task).to eq(task)
        expect(completion.due_at.in_time_zone(rule.time_zone))
          .to be_within(1.second).of(task.recurrence_rule.dates.first.end_of_day.in_time_zone(rule.time_zone))
      end

      context "when there is already a completion for the given date" do
        it "does not create a new task completion" do
          due_at = rule.dates.first.in_time_zone(rule.time_zone).end_of_day
          create(:task_completion, task: task, due_at: due_at)

          expect { subject.call }.to change(TaskCompletion, :count).by(0)
        end
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
