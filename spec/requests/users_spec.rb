require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /users #index" do
    let(:user) { FactoryBot.create(:user, :activated) }

    context "as an authenticated user" do
      before do
        log_in user
        get users_path
      end

      it "responds successfully" do
        expect(response).to have_http_status :ok
      end

      it "responds correct title" do
        expect(response.body).to include "<title>#{full_title("All users")}</title>"
      end

      it "doesn't display inactivated user" do
        inactivated_user = FactoryBot.create(:other_user)
        get users_path
        expect(response.body).not_to include inactivated_user.name
      end

      context "in pagination" do
        before do
          Faker::Name.unique.clear
          Faker::Internet.unique.clear
          FactoryBot.create_list(:mob_users, 30, :activated)
          get users_path
        end

        it "has a pagination" do
          pagination = '<ul class="pagination">'
          expect(response.body).to include pagination
        end

        it "has a link for each user" do
          User.page(1).each do |user|
            expect(response.body).to include "<a href=\"#{user_path(user)}\">"
          end
        end
      end

    end

    context "as a guest user" do
      it "redirects to root_path" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end


  describe "POST /users #create" do
    let(:user_params) { FactoryBot.attributes_for(:user) }
    let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }

    context "with valid params" do
      before { ActionMailer::Base.deliveries.clear }

      it "sign up" do
        expect {
          post users_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      it "redirects to root_path" do
        post users_path, params: { user: user_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
        # expect(is_logged_in?).to be_truthy    # 自動認証なら必要
      end

      it "has success flash message" do
        post users_path, params: { user: user_params }
        # expect(flash[:success]).to eq "Account activated!"  # 自動認証なら必要
        expect(flash[:info]).to eq "Please check your email to activate your account."  # 自動認証なら不要
      end

      it "doesn't has login status" do
        post users_path, params: { user: user_params }
        # expect(is_logged_in?).to be_truthy    # 自動認証なら必要
        expect(is_logged_in?).to be_falsy    # 自動認証なら不要
      end

      it "exists an email" do
        post users_path, params: { user: user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "hasn't yet been activated" do
        post users_path, params: { user: user_params }
        expect(User.last).not_to be_activated
      end
    end

    context "with invalid params (without name)" do
      it "doesn't sign up" do
        user_params[:name] = ""
        expect {
          post users_path, params: { user: user_params }
        }.not_to change(User, :count)
      end
    end
  end


  describe "GET /signup #new" do
    before { get signup_path }

    it "responds successfully" do
      expect(response).to have_http_status :ok
    end

    it "responds a correct title" do
      expect(response.body).to include "<title>#{full_title("Sign up")}</title>"
    end
  end


  describe "GET /users/:id/edit #edit" do
    let(:user)       { FactoryBot.create(:user,       :activated) }
    let(:other_user) { FactoryBot.create(:other_user, :activated) }

    context "as an authorized user" do
      before { log_in user }

      it "has a correct title" do
        get edit_user_path(user)
        expect(response.body).to include "<title>#{full_title("Edit user")}</title>"
      end
    end

    context "as an unauthorized user" do
      before do
        log_in user
        get edit_user_path(other_user)
      end

      it "doesn't have flash messages" do
        expect(flash).to be_empty
      end

      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest user" do
      it "has a flash" do
        get edit_user_path(user)
        expect(flash[:danger]).to include "Please log in."
      end

      it "redirects to login_path" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it "redirects to edit page when logged in" do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end

      it "does friendly forwarding only the first time and redirects the subsequent logins to the default" do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
        log_out
        log_in user
        expect(response).to redirect_to root_path
      end
    end
  end


  describe "GET /users/id #show" do
    let(:user) { FactoryBot.create(:user, :activated) }
    let(:inactivated_user) { FactoryBot.create(:other_user) }

    context "visit inactivated user" do
      it "redirects to root" do
        log_in user
        get user_path(inactivated_user)
        expect(response).to redirect_to root_url
      end
    end
  end


  describe "PATCH /users/:id #update" do
    let(:user)        { FactoryBot.create(:user,       :activated) }
    let(:other_user)  { FactoryBot.create(:other_user, :activated) }

    context "as an authorized user" do
      before { log_in user }
      
      it "doesn't change admin attribute via web" do
        user = FactoryBot.create(:user)
        expect(user).not_to be_admin
  
        log_in user

        patch user_path(user), params: { user: {
            current_password: user.password,
            admin:            true
          }
        }
        user.reload
        expect(user).not_to be_admin
      end

      context "with valid information" do
        let(:other_user_params) { FactoryBot.attributes_for(:other_user) }

        before { other_user_params[:current_password] = user.password }

        it "edits a user" do
          org_pass = User.last.password
          patch user_path(user), params: { user: other_user_params }
          user.reload
          aggregate_failures do
            expect(user.name).to eq other_user_params[:name]
            expect(user.email).to eq other_user_params[:email]
            expect(User.last.password).to eq org_pass
          end
        end
    
        it "redirects to users/:id/edit" do
          patch user_path(user), params: { user: other_user_params }
          expect(response).to redirect_to edit_user_path(user)
        end
    
        it "has a success flash message of 'Profile updated'" do
          patch user_path(user), params: { user: other_user_params }
          expect(flash[:success]).to include "Profile updated"
        end
      end

      context "with invalid information" do
        let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }
    
        context "with invalid current password" do
          before do
            invalid_user_params[:current_password] = ""
            patch user_path(user), params: { user: invalid_user_params }
          end

          it "doesn't edit a user" do
            user.reload
            aggregate_failures do
              expect(user.name).not_to eq invalid_user_params[:name]
              expect(user.email).not_to eq invalid_user_params[:email]
              expect(user.password).not_to eq invalid_user_params[:password]
              expect(user.password_confirmation).not_to eq invalid_user_params[:password_confirmation]
            end
          end

          it "redirects to edit page" do
            expect(response.body).to include "<title>#{full_title('Edit user')}</title>"
          end

          it "has a correct error message of 'Invalid password'" do
            expect(response.body).to include "Invalid password"
          end
        end

        context "with valid current password" do
          before do
            invalid_user_params[:current_password] = user.password
            patch user_path(user), params: { user: invalid_user_params }
          end

          it "doesn't edit a user" do
            user.reload
            aggregate_failures do
              expect(user.name).not_to eq invalid_user_params[:name]
              expect(user.email).not_to eq invalid_user_params[:email]
              expect(user.password).not_to eq invalid_user_params[:password]
              expect(user.password_confirmation).not_to eq invalid_user_params[:password_confirmation]
            end
          end
      
          it "redirects to edit page" do
            expect(response.body).to include "<title>#{full_title('Edit user')}</title>"
          end

          it "has correct error messages of 'The form contains 5 errors'" do
            expect(response.body).to include "The form contains 5 errors"
          end
        end
      end
    end

    context "as an unauthorized user" do
      before do
        other_user_params = FactoryBot.attributes_for(:other_user)
        log_in user
        patch user_path(other_user), params: { user: other_user_params }
      end

      it "doesn't have flash messages" do
        expect(flash).to be_empty
      end

      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest user" do
      let(:other_user_params) { FactoryBot.attributes_for(:other_user) }

      before do
        other_user_params[:current_password] = user.password
        patch user_path(user), params: { user: other_user_params }
      end

      it "doesn't edit a user" do
        org_pass = User.last.password
        user.reload
        aggregate_failures do
          expect(user.name).not_to eq other_user_params[:name]
          expect(user.email).not_to eq other_user_params[:email]
          expect(User.last.password).to eq org_pass
        end
      end

      it "redirects to login_path" do
        expect(response).to redirect_to login_path
      end

      it "has a danger flash message" do
        expect(flash[:danger]).to include "Please log in."
      end
    end
  end


  describe "DELETE /users/:id #destroy" do
    let!(:user)      { FactoryBot.create(:user,       :activated) }
    let(:other_user) { FactoryBot.create(:other_user, :activated) }
    let(:admin_user) { FactoryBot.create(:user, :admin) }

    context "as an authenticated user" do
      context "as an admin user" do
        before { log_in admin_user }
        
        it "deletes a user" do
          expect{
            delete user_path(user)
          }.to change(User, :count).by(-1)
        end
      end

      context "as a non-admin user" do
        before { log_in other_user }

        it "redirects to root_path" do
          delete user_path(user)
          expect(response).to redirect_to root_path
        end

        it "doesn't delete a user" do
          expect {
            delete user_path(user)
          }.not_to change(User, :count)
        end
      end
    end

    context "as a guest user" do
      it "redirects to login_path" do
        delete user_path(user)
        expect(response).to redirect_to login_url
      end

      it "doesn't delete" do
        expect {
          delete user_path(user)
        }.not_to change(User, :count)
      end
    end
  end


  describe 'GET /users/:id/following #following' do
    let(:user) { FactoryBot.create(:user, :activated) }
 
    context "as an authenticated user" do
      before do
        log_in user
        get following_user_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status :ok
      end

      it "responds a correct title" do
        expect(response.body).to include "<title>#{full_title("Following")}</title>"
      end
    end

    context "as a guest user" do
      it "redirects to the login page" do
        get following_user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end


  describe 'GET /users/:id/followers #followers' do
    let(:user) { FactoryBot.create(:user, :activated) }

    context "as an authenticated user" do
      before do
        log_in user
        get followers_user_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status :ok
      end

      it "responds a correct title" do
        expect(response.body).to include "<title>#{full_title("Followers")}</title>"
      end
    end

    context "as a guest user" do
      it "redirects to the login page" do
        get followers_user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end
end
