require "rails_helper"

RSpec.describe Habit, type: :model do
  subject { build(:habit) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
