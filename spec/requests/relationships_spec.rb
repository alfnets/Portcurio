require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "POST /relationships #create" do
    context "as an authenticated user" do
      let(:user) { FactoryBot.create(:user, :activated) }
      let(:other_user) { FactoryBot.create(:other_user, :activated) }

      before { log_in user }

      it "creates a relationship by the standard way" do
        expect{
          post relationships_path, params: { followed_id: other_user.id, userprofile_id: current_user.id }
        }.to change(Relationship, :count).by 1
      end

      it "creates a relationship by the Ajax" do
        expect{
          post relationships_path, params: { followed_id: other_user.id, userprofile_id: current_user.id }, xhr: true
        }.to change(Relationship, :count).by 1
      end
    end

    context "as a guest user" do
      it "redirects to login_path" do
        post relationships_path
        expect(response).to redirect_to login_path
      end

      it "doesn't create a relationship" do
        expect{
          post relationships_path
        }.not_to change(Relationship, :count)
      end
    end
  end


  describe "DELETE /relationships/:id #destroy" do
    let(:user)       { FactoryBot.create(:user, :activated) }
    let(:other_user) { FactoryBot.create(:other_user, :activated) }

    before do
      user.follow(other_user)
      @relationship = user.active_relationships.find_by(followed_id: other_user.id)
    end

    context "as an authenticated user" do
      before { log_in user }

      it "deletes a relationship by the standard way" do
        expect{
          delete relationship_path(@relationship), params: { userprofile_id: user.id }
        }.to change(Relationship, :count).by -1
      end

      it "deletes a relationship by the Ajax" do
        expect{
          delete relationship_path(@relationship), params: { userprofile_id: user.id }, xhr: true
        }.to change(Relationship, :count).by -1
      end
    end

    context "as a guest user" do
      it "redirects to login_path" do
        delete relationship_path(@relationship), params: { userprofile_id: user.id }
        expect(response).to redirect_to login_path
      end

      it "doesn't delete a relationship" do
        expect{
          delete relationship_path(@relationship), params: { userprofile_id: user.id }
        }.not_to change(Relationship, :count)
      end
    end
  end
end
