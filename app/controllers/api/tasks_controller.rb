class Api::TasksController < ApplicationController
  def index
    @tasks = Queries::TaskSearch.call(task_search_params)
  end

  def create
    @task = Tasks::CreateTask.call(create_task_params)

    render status: :created
  end

  def update
    @task = Task.find(params[:id])
    @task.update(update_task_params)

    render status: :ok
  end

  def destroy
    @task = Task.find(params[:id])
    @task.discard

    head :ok
  end

  private

  def create_task_params
    params
      .require(:task)
      .permit(:title, :recurring, :rrule)
      .reverse_merge(clerk_id: params[:user_clerk_id])
  end

  def update_task_params
    params
      .require(:task)
      .permit(:status, :title, :recurring, :rrule)
  end

  def task_search_params
    params
      .require(:search)
      .permit(:dueDate)
      .deep_transform_keys!(&:underscore)
      .reverse_merge(user_clerk_id: params[:user_clerk_id])
  end
end
