class Api::UsersController < ApplicationController
  def create
    @user = Users::SignIn.new(user_params).call

    if @user.valid?
      render status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :image)
  end
end
