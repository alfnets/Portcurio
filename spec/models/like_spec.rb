require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user)       { FactoryBot.create(:user) }
  let(:micropost)  { FactoryBot.create(:micropost, user: user) }
  let(:comment)    { FactoryBot.create(:comment, micropost: micropost, user: user) }

  context "attributes" do
    it "is valid with micropost, user" do
      like = micropost.likes.build(user: user)
      expect(like).to be_valid
    end

    it "is valid with comment, user" do
      like = comment.likes.build(user: user)
      expect(like).to be_valid
    end

    it "is invalid without a user" do
      like = micropost.likes.build(user: nil)
      like.valid?
      expect(like.errors[:user]).to include "must exist"
    end

    it "is invalid without a comment or micropost (only user)" do
      like = Like.new(user: user)
      like.valid?
      expect(like.errors[:likeable]).to include "must exist"
    end

  end
end
