module Users
  class SignIn
    def initialize(user_params)
      @user = User.find_or_initialize_by(email: user_params[:email])
      @user_params = user_params
    end

    def call
      update_user_from_params unless user.persisted?

      user
    end

    private

    attr_reader :user, :user_params

    def update_user_from_params
      user.assign_attributes(user_params)
      user.save
    end
  end
end
