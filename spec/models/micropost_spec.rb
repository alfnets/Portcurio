require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:micropost) { user.microposts.build(content: "Test post") }

  context "with valid attributes" do
    # コンテンツとユーザーがあれば有効な状態であること
    it "is valid with content and user" do
      expect(micropost).to be_valid
    end

    it "is valid with content equal to the boundary value" do
      micropost.content = "a" * 140
      expect(micropost).to be_valid
    end
  end

  
  context "with invalid attributes" do
    it "is invalid without a user_id" do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end

    it "is invalid without a content" do
      micropost.content = ""
      micropost.valid?
      expect(micropost.errors[:content_or_image_or_file_link]).to include "can't be blank"
    end

    it "is invalid with a blank content" do
      micropost.content = "   "
      micropost.valid?
      expect(micropost.errors[:content_or_image_or_file_link]).to include "can't be blank"
    end

    it "is invalid with a content at most 140 characters" do
      micropost.content = "a" * 141
      micropost.valid?
      expect(micropost.errors[:content]).to include "is too long (maximum is 140 characters)"
    end
  end


  context "sort" do
    it "is sorted by newest to oldest" do
      micropost.save
      expect(FactoryBot.create(:micropost, user: user)).to eq Micropost.first
    end
  end


  context "associations" do
    it "is associated its likes (delete)" do
      micropost.save
      micropost.likes.create!(user: user)
      expect {
        micropost.destroy
      }.to change(micropost.likes, :count).by(-1)
    end

    it "is associated its comments (delete)" do
      micropost.save
      micropost.comments.create!(content: "test comment", user: user)
      expect {
        micropost.destroy
      }.to change(micropost.comments, :count).by(-1)
    end
  end
end
