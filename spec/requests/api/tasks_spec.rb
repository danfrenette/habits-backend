require "rails_helper"

RSpec.describe "tasks", type: :request do
  describe "GET /tasks" do
    it "returns a list of tasks based on the params" do
      create_list(:task, 3, user: build(:user))

      get api_tasks_path(params: build_search_params), as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
      expect(json.first.keys).to contain_exactly("id", "title", "recurring", "status")
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
      task = create(:task, status: "active")

      patch api_task_path(task),
        params: build_params(title: "New Title"), as: :json

      expect(response).to be_successful
      expect(task.reload.title).to eq("New Title")
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
      userId: User.last.id
    }.merge(overrides)

    {search: params}
  end
end
