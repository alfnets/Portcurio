class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # POST /relationships
  def create
    @user = User.find(params[:followed_id])
    @userprofile = User.find(params[:userprofile_id])
    if current_user.follow(@user)
      relationship = current_user.active_relationships.find_by(followed_id: @user.id)
      notification = current_user.active_notifications.build(
        notificable: relationship,
        notified_id: @user.id
      )
      notification.save if notification.valid?
      if notification.notified.lineuid
        host_name = ENV.fetch("HOST", nil)
        url = "https://#{host_name}/users/#{notification.notifier_id}"
        message = {
          type: 'text',
          text: "#{notification.notifier.name}さんにフォローされました\n#{url}"
        }
        client.push_message(notification.notified.lineuid, message)
      end
    end
    # redirect_to @user
    # redirect_to request.referer
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js   # => app/views/relationships/create.js.erb
    # end
    respond_to do |format|
      format.html { redirect_back(fallback_location: @user) }
      format.js   # => app/views/relationships/create.js.erb
    end
  end

  # DELETE /relationships/:id
  def destroy
    @user = Relationship.find(params[:id]).followed
    @userprofile = User.find(params[:userprofile_id])
    current_user.unfollow(@user)
    relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    notification = current_user.active_notifications.find_by(
      notificable: relationship,
      notified_id: @user.id
    )
    notification.destroy if notification.present?
    # redirect_to @user
    # redirect_to request.referer
    respond_to do |format|
      format.html { redirect_back(fallback_location: @user) }
      format.js   # => app/views/relationships/destroy.js.erb
    end
  end
  
  # PATCH /relationships/:id(user_id)/subscribe
  def subscribe
    @user = User.find(params[:id])
    # relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    # relationship.update_attribute(:subscribed, true)
    current_user.subscribe(@user)
    @userprofile = User.find(params[:userprofile_id])
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
  # PATCH /relationships/:id(user_id)/unsubscribe
  def unsubscribe
    @user = User.find(params[:id])
    # relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    # relationship.update_attribute(:subscribed, false)
    current_user.unsubscribe(@user)
    @userprofile = User.find(params[:userprofile_id])
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
end
