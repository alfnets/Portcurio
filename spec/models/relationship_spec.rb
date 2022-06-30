require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user)         { FactoryBot.create(:user) }
  let(:other_user)   { FactoryBot.create(:user) }
  let(:relationship) { Relationship.new(follower: user, followed: other_user) }

  context "attributes" do
    it "is valid with follower and followed" do
      expect(relationship).to be_valid
    end

    it "is invalid without a follower" do
      relationship.follower = nil
      relationship.valid?
      expect(relationship.errors[:follower]).to include "must exist"
    end

    it "is invalid without a followed" do
      relationship.followed = nil
      relationship.valid?
      expect(relationship.errors[:followed]).to include "must exist"
    end
  end

  context "sort" do
    it "is most recent last" do
      relationship.save
      expect(Relationship.create(follower: other_user, followed: user)).to eq Relationship.first
    end
  end
end
