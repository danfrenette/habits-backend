class Api::TasksController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @tasks = user.tasks

    render json: @tasks
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)

    render json: @task
  end

  private

  def task_params
    params.require(:task).permit(:completed, :status)
  end
end
