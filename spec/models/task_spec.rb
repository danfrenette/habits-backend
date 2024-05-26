require "rails_helper"

RSpec.describe Task, type: :model do
  subject { create(:task) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:response).optional }
    it { should have_many(:completions).class_name("TaskCompletion").dependent(:destroy) }
    it { should have_one(:recurrence_rule) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }

    context "when response is present" do
      subject { build(:task, response: build(:response)) }

      it { should validate_uniqueness_of(:title).scoped_to(:response_id) }
    end
  end

  describe "scopes" do
    let!(:task_recurring_indefinitely) { create(:task, recurring: true, end_recurrence_at: nil) }
    let!(:task_recurring_until_future) { create(:task, recurring: true, end_recurrence_at: 1.week.from_now) }
    let!(:task_ended_recurrence) { create(:task, recurring: false, end_recurrence_at: 1.week.ago) }
    let!(:completed_task) { create(:task, :completed) }

    describe ".recurring_indefinitely" do
      it "includes tasks with no end_recurrence_at" do
        expect(Task.recurring_indefinitely).to include(task_recurring_indefinitely)
      end

      it "excludes tasks with an end_recurrence_at" do
        expect(Task.recurring_indefinitely).not_to include(task_recurring_until_future, task_ended_recurrence)
      end
    end

    describe ".recurring_until_future_date" do
      it "includes tasks with end_recurrence_at in the future" do
        expect(Task.recurring_until_future_date).to include(task_recurring_until_future)
      end

      it "excludes tasks with end_recurrence_at in the past or nil" do
        expect(Task.recurring_until_future_date).not_to include(task_recurring_indefinitely, task_ended_recurrence)
      end
    end

    describe ".actively_recurring" do
      it "includes tasks that are either recurring indefinitely or until a future date" do
        expect(Task.actively_recurring).to include(task_recurring_indefinitely, task_recurring_until_future)
      end

      it "excludes tasks with end_recurrence_at in the past" do
        expect(Task.actively_recurring).not_to include(task_ended_recurrence)
      end

      it "excludes tasks that are not active" do
        expect(Task.actively_recurring).not_to include(completed_task)
      end
    end
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(active: "active", completed: "completed")
        .backed_by_column_of_type(:string)
    end
  end
end
