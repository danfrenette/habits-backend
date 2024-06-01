require "rails_helper"

RSpec.describe TaskCompletion, type: :model do
  subject { create(:task_completion) }

  describe "associations" do
    it { should belong_to(:task) }
  end

  describe "validations" do
    it { should validate_presence_of(:due_at) }
    it { should validate_uniqueness_of(:task_id).scoped_to(:completed_at).case_insensitive }
  end
end
