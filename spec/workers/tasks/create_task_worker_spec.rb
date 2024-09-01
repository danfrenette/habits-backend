require "rails_helper"

RSpec.describe Tasks::CreateTaskWorker, type: :worker do
  before do
    allow(Tasks::CreateTaskAssignments).to receive(:call)
  end

  it "calls Tasks::CreateTaskAssignments with the correct task" do
    task = create(:task)

    described_class.new.perform(task.id)

    expect(Tasks::CreateTaskAssignments).to have_received(:call)
  end
end
