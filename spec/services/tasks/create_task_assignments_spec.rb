require "rails_helper"

RSpec.describe Tasks::CreateTaskAssignments, type: :service do
  subject { described_class.new(task) }

  let(:task) { create(:task, :recurring, :with_recurrence_rule, recurrence_ends_at: nil) }
  let(:rule) { task.recurrence_rule }

  describe "#call" do
    context "when the task is recurring" do
      it "creates a task assignment for the given date" do
        expect { subject.call }.to change(TaskAssignment, :count).by(1)

        assignment = TaskAssignment.last

        expect(assignment.task).to eq(task)
        expect(assignment.due_at.in_time_zone(rule.time_zone))
          .to be_within(1.second).of(task.recurrence_rule.dates.first.end_of_day.in_time_zone(rule.time_zone))
      end

      context "when there is already a assignment for the given date" do
        it "does not create a new task assignment" do
          due_at = rule.dates.first.in_time_zone(rule.time_zone).end_of_day
          create(:task_assignment, task: task, due_at: due_at)

          expect { subject.call }.to change(TaskAssignment, :count).by(0)
        end
      end
    end

    context "when the task is not recurring" do
      let(:task) { create(:task, :non_recurring) }

      it "raises an error" do
        expect { subject.call }.to raise_error(Tasks::CreateTaskAssignments::TaskNotRecurringError)
      end
    end
  end
end
