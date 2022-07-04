require 'rails_helper'

RSpec.describe "Users", type: :system do
  
  describe "sign up" do
    let(:user) { FactoryBot.build(:user) }
    let(:activated_user) { FactoryBot.create(:user, :activated) }

    context "with valid params" do
      it "sign up" do
        visit signup_path
        fill_in "Name",         with: user.name
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Create my account"
    
        aggregate_failures do
          expect(page).to have_current_path root_path
          # expect(page.body).to include user.name # 自動認証なら必要
          expect(page.body).to include "Please check your email to activate your account."  # 自動認証なら不要
        end
      end
    end

    context "with invalid params" do
      it "has error messages" do
        visit signup_path
        fill_in "Name",         with: ""
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Create my account"
    
        aggregate_failures do
          expect(page).to have_selector "div.error_explanation"
          expect(page).to have_selector "div.field_with_errors"
        end
      end
    end

    context "logging existed user" do
      before { log_in activated_user }
      
      it "redirects to root_path" do
        visit signup_path
        expect(page).to have_current_path root_path
      end
    end
  end


  describe "resends activate mail" do
    let(:user) { FactoryBot.create(:user) }
    let(:activated_user) { FactoryBot.create(:user, :activated) }

    context "with valid params" do
      it "sign up" do
        visit signup_path
        fill_in "Name",         with: user.name        
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Create my account"
    
        aggregate_failures do
          expect(page).to have_current_path root_path
          expect(page.body).to include "Resend the email to activate your account. Please check your email."
        end
      end
    end

    context "with invalid params" do
      it "that is password confirmation sign up" do
        visit signup_path
        fill_in "Name",         with: user.name        
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: ""
        click_button "Create my account"
    
        aggregate_failures do
          expect(page.body).to include "Password confirmation doesn&#39;t match Password"
          expect(page.body).to_not include "Email has already been taken"
        end
      end
    end

    context "with the activated user params" do
      it "doesn't resends activate email after clicking Create button" do
        visit signup_path
        fill_in "Name",         with: activated_user.name
        fill_in "Email",        with: activated_user.email
        fill_in "Password",     with: activated_user.password
        fill_in "Confirmation", with: activated_user.password
        click_button "Create my account"
    
        aggregate_failures do
          expect(page.body).to include "Email has already been taken"
        end
      end
    end
  end

  describe "deletes a itself account" do
    let(:user) { FactoryBot.create(:user, :activated) }
    let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }

    before { log_in user }

    context "with valid password" do
      it "sends delete mail" do
        visit delete_user_path(user)
        fill_in "Current Password", with: user.password
        click_button "Send email to delete the account"
    
        aggregate_failures do
          expect(page.body).to include "Please check your email to delete your account."
          expect(page.body).to include "Delete your account"
          expect(page.body).to include user.name
        end
      end

      it "deletes the account" do
        user.create_delete_digest
        visit exec_account_delete_url(user.delete_token, email: user.email)
      
        aggregate_failures do
          expect(page.body).to include "User deleted"
          expect(page).to have_current_path root_path
          expect(page).to have_link "登録はコチラ", href: signup_path
        end
      end
    end

    context "with invalid password" do
      it "sends delete mail" do
        visit delete_user_path(user)
        fill_in "Current Password", with: invalid_user_params[:password]
        click_button "Send email to delete the account"
    
        aggregate_failures do
          expect(page.body).to include "Invalid password."
          expect(page.body).to include "Delete your account"
        end
      end
    end
  end


  describe "access to a user index page" do
    let(:admin) { FactoryBot.create(:user, :admin) }
    let!(:user) { FactoryBot.create(:user, :activated) }

    context "as a admin user" do
      it "has a link to delete" do
        log_in admin
        visit users_path
        expect(page).to have_link "delete"
      end
    end

    context "as a non-admin user" do
      it "doesn't have a link to delete" do
        log_in user
        visit users_path
        expect(page).not_to have_link "delete"
      end
    end
  end


  describe "access to the following page of the user" do
    let(:user) { FactoryBot.create(:user, :activated) }

    context "as an authenticated user" do
      let(:user_with_relationships) { FactoryBot.send(:create_relationships) }
      let!(:following) { user_with_relationships.following }

      before { log_in user_with_relationships }

      it "displays the correct number of following user" do
        visit following_user_path(user_with_relationships)

        expect(following).not_to be_empty

        expect(page).to have_content("#{following.count} フォロー")
        following.page(1).each do |follow|
          expect(page).to have_link follow.name, href: user_path(follow)
        end
      end
    end
  end


  describe "access to the followers page of the user" do
    let(:user) { FactoryBot.create(:user) }

    context "as an authenticated user" do
      let(:user_with_relationships) { FactoryBot.send(:create_relationships) }
      let!(:followers) { user_with_relationships.followers }

      before { log_in user_with_relationships }

      it "displays the correct number of followers" do
        visit followers_user_path(user_with_relationships)

        expect(followers).not_to be_empty

        expect(page).to have_content("#{followers.count} フォロワー")
        followers.page(1).each do |follower|
          expect(page).to have_link follower.name, href: user_path(follower)
        end
      end
    end
  end
end
