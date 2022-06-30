class UserMailer < ApplicationMailer
  helper :application
  
  def account_activation(user)
    @user = user
    mail       to: user.email,
          subject: "Account activation"
    # => return: mail object (text/html)
    #   example: mail.deliver
  end

  def account_delete(user)
    @user = user
    mail       to: user.email,
          subject: "Account delete"
  end

  def account_delete_comp(user)
    @user = user
    mail       to: user.email,
          subject: "Account delete complete"
  end

  # @user.send_reset_email
  # UserMailer.password_reset(self).deliver_now
  def password_reset(user)
    @user = user
    mail       to: user.email,
          subject: "Password reset"
  end
end
