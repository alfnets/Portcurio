require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user, :activated) }

  describe "login" do
    before do
      get login_path
    end

    context "with valid params" do
      it "display the dashboard" do
        visit login_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"

        aggregate_failures do
          expect(page).to have_current_path root_path
          expect(page).not_to have_selector "a[href=\"#{login_path}\"]"
          expect(page).to have_selector "a[href=\"#{logout_path}\"]"
          expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
          expect(page.body).to include user.name
        end
      end
    end

    context "with invalid params" do
      it "display error message once" do
        visit login_path
        fill_in "Email",    with: ""
        fill_in "Password", with: ""
        click_button "Log in"

        expect(page).to have_selector 'div.alert.alert-danger'

        visit root_path
        expect(page).not_to have_selector 'div.alert.alert-danger'
      end
    end
  end
end
