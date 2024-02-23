require "rails_helper"

RSpec.describe "tasks", type: :request do
  describe "GET /users/:user_id/habits" do
    it "returns a list of tasks for a user" do
      user = create(:user)
      tasks = create_list(:task, 3, user: user)

      get api_user_tasks_path(user)

      expect(response).to be_successful
      expect(response.body).to eq(tasks.to_json)
    end
  end
end
