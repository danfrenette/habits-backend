require "rails_helper"

RSpec.describe Response, type: :model do
  subject { build(:response) }

  describe "associations" do
    it { should belong_to(:habit) }
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
  end
end
