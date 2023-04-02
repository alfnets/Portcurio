class AccountActivationsController < ApplicationController
  
  # GET /account_activations/:id/edit
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      admin = User.find_by(admin: true);
      if current_user.follow(admin)
        relationship = current_user.active_relationships.find_by(followed_id: admin.id)
        notification = current_user.active_notifications.build(
          notificable: relationship,
          notified_id: admin.id
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
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      flash[:danger]  = "Invalid activation link"
      redirect_to root_url
    end
  end
end
