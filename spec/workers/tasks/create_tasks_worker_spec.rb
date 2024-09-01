require "rails_helper"

RSpec.describe Tasks::CreateTasksWorker, type: :worker do
  before do
    allow(Tasks::CreateTaskWorker).to receive(:perform_async)
  end

  context "when a task is both recurring and active" do
    it "calls create_task_assignments on the task" do
      task = create(:task, :recurring, :active, :with_recurrence_rule, recurrence_ends_at: nil)

      described_class.new.perform

      expect(Tasks::CreateTaskWorker).to have_received(:perform_async).with(task.id)
    end
  end

  context "when a task is recurring but not active (completed)" do
    it "does not call create_task_assignments on the task" do
      create(:task, :recurring, :completed, :with_recurrence_rule, recurrence_ends_at: Date.yesterday)

      described_class.new.perform

      expect(Tasks::CreateTaskWorker).not_to have_received(:perform_async)
    end
  end

  context "when a task is active but not recurring" do
    it "does not call create_task_assignments on the task" do
      create(:task, :non_recurring, :active, recurrence_ends_at: nil)

      described_class.new.perform

      expect(Tasks::CreateTaskWorker).not_to have_received(:perform_async)
    end
  end

  context "when a task is neither active nor recurring" do
    it "calls create_task_assignments on active recurring tasks" do
      create(:task, :non_recurring, :completed, recurrence_ends_at: nil)

      described_class.new.perform

      expect(Tasks::CreateTaskWorker).not_to have_received(:perform_async)
    end
  end
end
