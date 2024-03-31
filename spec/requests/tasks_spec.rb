require "rails_helper"

RSpec.describe "tasks", type: :request do
  describe "GET /users/:user_id/tasks" do
    it "returns a list of tasks for a user" do
      user = create(:user)
      tasks = create_list(:task, 3, user: user)

      get api_user_tasks_path(user)

      expect(response).to be_successful
      expect(response.body).to eq(tasks.to_json)
    end
  end

  describe "POST /users/:user_id/tasks" do
    it "creates a new task" do
      user = create(:user)
      expect {
        post api_user_tasks_path(user),
          params: build_params, as: :json
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /tasks/:id" do
    it "updates a task" do
      task = create(:task, status: "pending")

      patch api_task_path(task),
        params: build_params(status: "completed"), as: :json

      expect(response).to be_successful
      expect(task.reload.status).to eq("completed")
    end
  end

  def build_params(overrides = {})
    params = {
      status: "pending",
      title: "Some task"
    }.merge(overrides)

    {task: params}
  end
end
