require "rails_helper"

RSpec.describe "tasks", type: :request do
  describe "GET /api/users/:user_clerk_id/tasks" do
    it "returns a list of tasks based on the params" do
      user = create(:user)
      create_list(:task, 3, user: user)

      get api_user_tasks_path(user.clerk_id, params: build_search_params), as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
      expect(json.first.keys).to contain_exactly("id", "title", "recurring", "status")
    end
  end

  describe "POST /api/users/:user_clerk_id/tasks" do
    it "creates a new task" do
      user = create(:user)
      expect {
        post api_user_tasks_path(user.clerk_id),
          params: build_params, as: :json
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /api/tasks/:id" do
    it "updates a task" do
      task = create(:task, status: "active")

      patch api_task_path(task),
        params: build_params(title: "New Title"), as: :json

      expect(response).to be_successful
      expect(task.reload.title).to eq("New Title")
    end
  end

  describe "DELETE /api/tasks/:id" do
    it "discards the task" do
      task = create(:task)

      expect { delete api_task_path(task) }.to change(Task, :count).by(-1)
    end
  end

  def build_params(overrides = {})
    params = {
      recurring: "false",
      status: "active",
      title: "Some task"
    }.merge(overrides)

    {task: params}
  end

  def build_search_params(overrides = {})
    params = {
      user_clerk_id: User.last.clerk_id
    }.merge(overrides)

    {search: params}
  end
end
