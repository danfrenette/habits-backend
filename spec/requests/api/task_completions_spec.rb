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

  describe "PATCH /api/task_completions/:id" do
    it "updates a task completion" do
      task_completion = create(:task_completion, completed_at: nil)

      patch api_task_completion_path(task_completion),
        params: build_params(completed_at: Time.zone.now), as: :json

      expect(response).to be_successful
      expect(task_completion.reload.completed_at).to be_within(1.second).of(Time.zone.now)
    end
  end

  def build_params(overrides = {})
    params = {
      due_at: Time.zone.now.end_of_day,
      completed_at: nil
    }.merge(overrides)

    {task_completion: params}
  end
end
