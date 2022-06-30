require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:user) { FactoryBot.create(:user) }
  
  describe "GET /home" do
    before { get home_path }

    context "as a authenticated user" do
      # before do
      #   log_in user
      #   get home_path
      # end

      it "responds successfully" do
        expect(response).to have_http_status(:ok)
      end

      it "responds right title" do
        expect(response.body).to include "<title>#{site_name}</title>"
      end

      # it "responds dashboard page" do
      #   expect(response.body).to include user.name
      # end
    end


    context "as a guest user" do
      it "responds successfully" do
        expect(response).to have_http_status(:ok)
      end
  
      it "responds right title" do
        expect(response.body).to include "<title>#{site_name}</title>"
      end
    end

  end

  # describe "GET /help" do
  #   before { get help_path }
  #   it "responds successfully" do
  #     expect(response).to have_http_status(200)
  #   end

  #   it "responds right title" do
  #     expect(response.body).to include "<title>#{full_title("Help")}</title>"
  #   end
  # end

  # describe "GET /about" do
  #   before { get about_path }
  #   it "responds successfully" do
  #     expect(response).to have_http_status(200)
  #   end

  #   it "responds right title" do
  #     expect(response.body).to include "<title>#{full_title("About")}</title>"
  #   end
  # end

  # describe "GET /contact" do
  #   before { get contact_path }
  #   it "responds successfully" do
  #     expect(response).to have_http_status(200)
  #   end

  #   it "responds right title" do
  #     expect(response.body).to include "<title>#{full_title("Contact")}</title>"
  #   end
  # end
end
