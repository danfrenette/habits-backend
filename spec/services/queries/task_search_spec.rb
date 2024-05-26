require "rails_helper"

RSpec.describe Queries::TaskSearch, type: :query do
  describe ".call" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    let!(:task1) { create(:task, user: user1) }
    let!(:task2) { create(:task, user: user2) }

    context "when filtering by user_id" do
      it "returns tasks for the specified user" do
        result = described_class.call(user_clerk_id: user1.clerk_id)

        expect(result).to contain_exactly(task1)
      end
    end

    context "when filters are blank" do
      it "returns all tasks" do
        result = described_class.call({})

        expect(result).to contain_exactly(task1, task2)
      end
    end
  end
end
