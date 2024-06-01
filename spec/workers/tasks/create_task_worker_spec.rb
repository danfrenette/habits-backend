require "rails_helper"

RSpec.describe Tasks::CreateTaskWorker, type: :worker do
  before do
    allow(Tasks::CreateTaskCompletions).to receive(:call)
  end

  it "calls Tasks::CreateTaskCompletions with the correct task" do
    task = create(:task)

    described_class.new.perform(task.id)

    expect(Tasks::CreateTaskCompletions).to have_received(:call)
  end
end
