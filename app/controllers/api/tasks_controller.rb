class Api::TasksController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @tasks = user.tasks

    render json: @tasks
  end

  def create
    user = User.find(params[:user_id])
    @task = user.tasks.create(task_params)

    render json: @task, status: :created
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)

    render json: @task
  end

  private

  def task_params
    params.require(:task).permit(:status, :title)
  end
end
