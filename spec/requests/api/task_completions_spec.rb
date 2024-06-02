require "rails_helper"

RSpec.describe "Task Completions API", type: :request do
  describe "GET /api/users/:user_clerk_id/task_completions" do
    it "returns a list of task completions for a user" do
      task = create(:task)
      create_list(:task_completion, 3, task: task)

      get api_user_task_completions_path(task.user.clerk_id), as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
      expect(json.first.keys).to contain_exactly("id", "taskId", "completedAt", "dueAt", "taskTitle")
    end
  end
end
