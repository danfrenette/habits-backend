class Api::TaskCompletionsController < ApplicationController
  def index
    user = User.find_in_clerk(params[:user_clerk_id])

    @task_completions = user.task_completions.includes(:task)
  end

  def update
    @task_completion = TaskCompletion.find(params[:id])
    @task_completion.update(update_task_completion_params)

    render status: :ok
  end

  private

  def update_task_completion_params
    params
      .require(:task_completion)
      .permit(:completed_at)
  end
end
