require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user: user) }
  let(:comment)   { FactoryBot.build(:comment, micropost: micropost, user: user) }


  context "attributes" do
    it "is valid with content, micropost, and user" do
      expect(comment).to be_valid
    end

    it "is invalid without a user" do
      comment.user = nil
      comment.valid?
      expect(comment.errors[:user]).to include "must exist"
    end

    it "is invalid without a micropost" do
      comment.micropost = nil
      comment.valid?
      expect(comment.errors[:micropost]).to include "must exist"
    end

    it "is invalid without a content" do
      comment.content = nil
      comment.valid?
      expect(comment.errors[:content]).to include "can't be blank"
    end

    it "is invalid with a blank content" do
      comment.content = "   "
      comment.valid?
      expect(comment.errors[:content]).to include "can't be blank"
    end

    it "is invalid with a content at most 140 characters" do
      comment.content = "a" * 141
      comment.valid?
      expect(comment.errors[:content]).to include "is too long (maximum is 140 characters)"
    end
  end

  context "sort" do
    it "is most recent first" do
      comment.save
      expect(FactoryBot.create(:comment, micropost: micropost, user: user)).to eq Comment.first
    end
  end
end
