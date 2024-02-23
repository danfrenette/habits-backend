class Api::TasksController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @tasks = user.tasks

    render json: @tasks
  end
end
