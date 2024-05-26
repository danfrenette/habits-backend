require "rails_helper"

RSpec.describe "habits", type: :request do
  describe "GET /habits" do
    it "returns a list of habits for a user" do
      user = create(:user)
      create_list(:habit, 3, user: user)

      get api_user_habits_path(user.clerk_id), as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
      expect(json.first.keys).to contain_exactly("id", "name", "current")
    end
  end

  describe "POST /habits" do
    let(:user) { create(:user) }
    let(:habit_params) do
      {
        habit: {
          name: habit_name,
          current: habit_is_current
        }
      }
    end
    let(:habit_name) { "Test Habit" }
    let(:habit_is_current) { false }

    context "the habit hasn't been created in the database" do
      it "creates a habit with the correct attributes" do
        expect { post api_user_habits_path(user.clerk_id), params: habit_params, as: :json }.to change(Habit, :count).by(1)

        expect(response).to be_successful
        expect(Habit.last).to have_attributes(
          name: habit_name,
          current: habit_is_current
        )
      end
    end

    context "the user has already created this habit" do
      before do
        create(:habit, name: habit_name, user: user)
      end

      it "does not create a new habit" do
        expect { post api_user_habits_path(user.clerk_id), params: habit_params }
          .not_to change(Habit, :count)

        expect(response).not_to be_successful
      end
    end
  end
end
