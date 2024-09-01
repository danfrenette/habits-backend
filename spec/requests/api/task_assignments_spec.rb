require "rails_helper"

RSpec.describe "Task Assignments API", type: :request do
  describe "GET /api/users/:user_clerk_id/task_assignments" do
    it "returns a list of task assignments for a user" do
      task = create(:task)
      create_list(:task_assignment, 3, task: task)

      get api_user_task_assignments_path(task.user.clerk_id), as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
      expect(json.first.keys).to contain_exactly("id", "taskId", "completedAt", "dueAt", "taskTitle")
    end
  end

  describe "PATCH /api/task_assignments/:id" do
    it "updates a task assignment" do
      task_assignment = create(:task_assignment, completed_at: nil)

      patch api_task_assignment_path(task_assignment),
        params: build_params(completed_at: Time.zone.now), as: :json

      expect(response).to be_successful
      expect(task_assignment.reload.completed_at).to be_within(1.second).of(Time.zone.now)
    end
  end

  def build_params(overrides = {})
    params = {
      due_at: Time.zone.now.end_of_day,
      completed_at: nil
    }.merge(overrides)

    {task_assignment: params}
  end
end
