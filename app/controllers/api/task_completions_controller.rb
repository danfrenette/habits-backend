class Api::TaskCompletionsController < ApplicationController
  def index
    user = User.find_in_clerk(params[:user_clerk_id])

    @task_completions = user.task_completions.includes(:task)
  end
end
