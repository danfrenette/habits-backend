class Api::HabitsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @habits = user.habits

    render json: @habits
  end

  def create
    habit = Habit.new(habit_params)

    if habit.save
      render json: habit, status: :created
    else
      render json: habit.errors, status: :unprocessable_entity
    end
  end

  private

  def habit_params
    params
      .require(:habit)
      .permit(:user, :name, :current)
      .reverse_merge(user: User.find(params[:user_id]))
  end
end
