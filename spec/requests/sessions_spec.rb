require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }

  describe "GET /login #new" do
    it "responds successfully" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end


  describe "POST /login #create" do
    it "log in and redirect to dashboard" do
      post login_path, params: { session: { email:    user.email,
                                            password: user.password} }
      aggregate_failures do
        expect(response).to redirect_to root_path
        expect(is_logged_in?).to be_truthy
      end
    end

    context "with 'remember me'" do
      it "stores the remember token in cookies" do
        post login_path, params: { session: { email:    user.email,
                                              password: user.password,
                                              remember_me: 1 }}
        expect(cookies[:remember_token]).not_to be_blank
      end
    end
    
    context "without 'remember me'" do
      it "doesn't store the remember token in cookies" do
        post login_path, params: { session: { email:    user.email,
                                              password: user.password,
                                              remember_me: 0 }}
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end


  describe "DELETE /logout #destroy" do
    before do
      post login_path, params: { session: { email:    user.email,
                                            password: user.password } }
    end

    it "logout" do
      expect(logged_in?).to be_truthy

      delete logout_path
      expect(is_logged_in?).to be_falsey
    end

    it "isn't error logouting twice" do
      2.times { delete logout_path }
      expect(response).to redirect_to root_path
    end
  end
end
