require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user)          { FactoryBot.create(:user) }
  let(:other_user)    { FactoryBot.create(:user) }
  let(:micropost)     { FactoryBot.create(:micropost, user: user) }
  let(:comment)       { FactoryBot.create(:comment, micropost: micropost, user: user)}
  let(:like)          { micropost.likes.create(user: other_user) }
  let(:relationship)  { Relationship.create(follower: other_user, followed: user) }
  let(:notification)  { Notification.new(notifier: user, notified: other_user) }

  context "attributes" do
    it "is valid with notifier, notified, micropost" do
      notification.notificable = micropost
      expect(notification).to be_valid
    end

    it "is valid with notifier, notified, comment" do
      notification.notificable = comment
      expect(notification).to be_valid
    end

    it "is valid with notifier, notified, like" do
      notification.notificable = like
      expect(notification).to be_valid
    end

    it "is valid with notifier, notified, relationship" do
      notification.notificable = relationship
      expect(notification).to be_valid
    end

    it "is invalid without a notifier" do
      notification.notificable = micropost
      notification.notifier    = nil
      notification.valid?
      expect(notification.errors[:notifier]).to include "must exist"
    end

    it "is invalid without a notified" do
      notification.notificable = micropost
      notification.notified    = nil
      notification.valid?
      expect(notification.errors[:notified]).to include "must exist"
    end

    it "is invalid without a notificable" do
      notification.notificable = nil
      notification.valid?
      expect(notification.errors[:notificable]).to include "must exist"
    end
  end

  context "methods" do
    it "has a check method" do
      notification.notificable = micropost
      expect(notification.checked).to be false
      notification.check
      expect(notification.checked).to be true
    end
  end
end
