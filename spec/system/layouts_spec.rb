require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  let(:user) { FactoryBot.create(:user, :activated) }

  describe "access to root_path" do
    context "as a authenticated user" do
      let(:user_with_relationships) { FactoryBot.send(:create_relationships) }
      let(:following_count) { user_with_relationships.following.count }
      let(:followers_count) { user_with_relationships.followers.count }

      before { log_in user_with_relationships }

      it "access to root_path after log in" do
        expect(page).to have_current_path root_path
      end

      it "displays statistics following and followers" do  
        aggregate_failures do
          expect(page).to have_content("#{following_count} フォロー")
          expect(page).to have_content("#{followers_count} フォロワー")
        end
      end

      it "displays correct feeds" do
        user.feed.page(1).each do |micropost|
          expect(page).to have_content(CGI.escapeHTML(micropost.content))
        end
      end
    end

    context "as a guest user" do
      it "has links are two root_paths, about_path, contact_path, login_path, signup_path" do
        visit root_path

        expect(page).to have_link nil, href: root_path, count: 2
        # expect(page).to have_link 'Help', href: help_path
        # expect(page).to have_link 'About', href: about_path
        # expect(page).to have_link 'Contact', href: contact_path
        expect(page).to have_link "Log in", href: login_path
        expect(page).to have_link "登録はコチラ", href: signup_path
      end
    end
  end


  describe "access to the user profile page" do
    context "as a authenticated user" do
      let(:user_with_relationships) { FactoryBot.send(:create_relationships) }
      let(:following_count) { user_with_relationships.following.count }
      let(:followers_count) { user_with_relationships.followers.count }
      
      it "displays statistics following and followers" do  
        log_in user_with_relationships
        click_link "view my profile"
        aggregate_failures do
          expect(page).to have_current_path user_path(user_with_relationships)
          expect(page).to have_content("#{following_count} フォロー")
          expect(page).to have_content("#{followers_count} フォロワー")
        end
      end
    end
  end


  describe "header" do
    context "as an authenticated user" do
      before do
        log_in user
        visit root_path
      end

      describe "Account" do
        before { click_link "Account" }

        it "clicks the Profile to move to user's profile" do
          click_link "Profile"
          expect(page).to have_current_path user_path(user)
        end

        it "clicks the Sessings to move to user's setting" do
          click_link "Setting"
          expect(page).to have_current_path edit_user_path(user)
        end

        it "clicks the Log out to move to log out" do
          click_link "Log out"
          expect(page).to have_current_path root_path
        end
      end

      it "clicks the logo to move to root" do
        click_link "Profile"
        click_link "service_logo"
        expect(page).to have_current_path root_path
      end

      it "clicks the Home to move to root" do
        click_link "Profile"
        click_link "Home"
        expect(page).to have_current_path root_path
      end

      # it "click the Help to move to help" do
      #   click_link "Help"
      #   expect(page).to have_current_path help_path
      # end
    end

    context "as a guest user" do
      before { visit root_path }

      it "clicks the Log in to move to log in" do
        click_link 'Log in'
        expect(page).to have_current_path login_path
      end

      it "clicks the logo to move to root" do
        click_link "Log in"
        click_link "service_logo"
        expect(page).to have_current_path root_path
      end

      it "clicks the Home to move to root" do
        click_link "Log in"
        click_link "Home"
        expect(page).to have_current_path root_path
      end

      # it "clicks the Help to move to help" do
      #   click_link "Help"
      #   expect(page).to have_current_path help_path
      # end
    end
  end

  
  describe "footer" do
    context "as an authenticated user" do
      before do
        log_in user
        visit root_path
      end

      # it "clicks the About to move to about" do
      #   click_link "About"
      #   expect(page).to have_current_path about_path
      # end

      # it "clicks the Contact to move to contact" do
      #   click_link "Contact"
      #   expect(page).to have_current_path contact_path
      # end
    end

    context "as a guest user" do
      before { visit root_path }

      # it "clicks the About to move to about" do
      #   click_link "About"
      #   expect(page).to have_current_path about_path
      # end

      # it "clicks the Contact to move to contact" do
      #   click_link "Contact"
      #   expect(page).to have_current_path contact_path
      # end
    end
  end
end