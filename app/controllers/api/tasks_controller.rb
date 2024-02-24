class Api::TasksController < ApplicationController
  def index
    @tasks = Queries::TaskSearch.call(task_search_params)
  end

  def create
    user = User.find(params[:user_id])
    @task = user.tasks.create(task_params)

    render status: :created
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)

    render status: :ok
  end

  private

  def task_params
    params.require(:task).permit(:status, :title)
  end

  def task_search_params
    params.require(:search).permit(:userId, :dueDate).deep_transform_keys!(&:underscore)
  end
end
