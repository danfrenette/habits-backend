require "rails_helper"

RSpec.describe Task, type: :model do
  subject { create(:task) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:response).optional }
    it { should have_one(:recurrence_rule) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }

    context "when response is present" do
      subject { build(:task, response: build(:response)) }

      it { should validate_uniqueness_of(:title).scoped_to(:response_id) }
    end
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(pending: "pending", completed: "completed")
        .backed_by_column_of_type(:string)
    end
  end
end
