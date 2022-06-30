require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "POST /microposts" do
    context "as an authenticated user" do
      # 後で書く
    end

    context "as a guest user" do
      it "redirects to login_path" do
        post microposts_path, params: { micropost: { content: "Test post" } }
        expect(response).to redirect_to login_path
      end

      it "doesn't create a post" do
        expect{
          post microposts_path, params: { micropost: { content: "Test post" } }
        }.not_to change(Micropost, :count)
      end
    end
  end


  describe "DELETE /microposts/id" do
    let!(:micropost) { FactoryBot.create(:micropost) }

    context "as an authorized user" do
      # 後で書く
    end

    context "as an unauthorized user" do
      before do
        wrong_user = FactoryBot.create(:user, :activated)
        log_in(wrong_user)
      end

      it "redirects to root_url" do
        delete micropost_path(micropost)
        expect(response).to redirect_to root_url
      end

      it "does't delete a post" do
        expect {
          delete micropost_path(micropost)
        }.not_to change(Micropost, :count)
      end
    end

    context "as a guest user" do
      it "redirects to login_path" do
        delete micropost_path(micropost)
        expect(response).to redirect_to login_path
      end

      it "doesn't delete a post" do
        expect{
          delete micropost_path(micropost)
        }.not_to change(Micropost, :count)
      end
    end
  end
end
