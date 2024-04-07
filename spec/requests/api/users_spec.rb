require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    let(:user_params) do
      {
        user: {
          email: user_email,
          name: user_name,
          image: user_image
        }
      }
    end
    let(:user_email) { "test@example.com" }
    let(:user_name) { "Test User" }
    let(:user_image) { "https://example.com/test.png" }

    context "the user hasn't been created in the database" do
      it "creates a user with the correct attributes" do
        expect { post api_users_path, params: user_params, as: :json }.to change(User, :count).by(1)

        expect(response).to be_successful
        expect(response).to have_http_status(:created)
        expect(User.last).to have_attributes(
          email: user_email,
          name: user_name,
          image: user_image
        )
      end
    end

    context "the user has been created in the database" do
      before do
        create(:user, email: user_email, name: user_name, image: user_image)
      end

      it "does not create a new user" do
        expect { post api_users_path, params: user_params, as: :json }.not_to change(User, :count)

        expect(response).to be_successful
        expect(response).to have_http_status(:created)
      end
    end
  end
end
