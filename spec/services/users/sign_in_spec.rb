require "rails_helper"

RSpec.describe Users::SignIn do
  subject { described_class.new(user_params) }
  let(:user_params) do
    { email: user_email, name: user_name, image: user_image }
  end
  let(:user_email) { "test@example.com" }
  let(:user_name) { "Test User" }
  let(:user_image) { "https://example.com/test.png" }

  describe "#call" do
    context "when the user is a new record" do
      it "creates a new user" do

        expect { subject.call }.to change(User, :count).by(1)

        expect(User.last).to have_attributes(
          email: user_email,
          name: user_name,
          image: user_image,
        )
      end
    end

    context "when the user already exists with the email from params" do
      it "creates a new user" do
        create(:user, email: user_email)

        expect { subject.call }.to change(User, :count).by(0)
      end
    end
  end
end
