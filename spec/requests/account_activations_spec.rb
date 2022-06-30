require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /account_activations/:id/edit #edit" do
    let(:user_params) { FactoryBot.attributes_for(:user) }

    before do
      post users_path, params: { user: user_params }
      @user = controller.instance_variable_get(:@user)
    end

    context "with valid token and email" do
      it "activates user" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it "redirects to root_path" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(response).to redirect_to root_path
      end

      it "logs in" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(is_logged_in?).to be_truthy
      end
    end

    context "with invalid attributes" do
      it "doesn't log in with invalid token" do
        get edit_account_activation_path("invalid_token", email: @user.email)
        expect(is_logged_in?).not_to be_truthy
      end

      it "doesn't log in with invalid email" do
        get edit_account_activation_path(@user.activation_token, email: "wrong email")
        expect(is_logged_in?).not_to be_truthy
      end
    end
  end
end
