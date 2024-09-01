class Api::TaskAssignmentsController < ApplicationController
  def index
    user = User.find_in_clerk(params[:user_clerk_id])

    @task_assignments = user.task_assignments.includes(:task)
  end

  def update
    @task_assignment = TaskAssignment.find(params[:id])
    @task_assignment.update(update_task_assignment_params)

    render status: :ok
  end

  private

  def update_task_assignment_params
    params
      .require(:task_assignment)
      .permit(:completed_at)
  end
end
