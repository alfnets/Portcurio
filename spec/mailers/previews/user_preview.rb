# Preview all emails at http://localhost/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at /rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at /rails/mailers/user_mailer/account_delete
  def account_delete
    user = User.first
    user.delete_token = User.new_token
    UserMailer.account_delete(user)
  end

  # Preview this email at /rails/mailers/user_mailer/account_delete_comp
  def account_delete_comp
    user = User.first
    UserMailer.account_delete_comp(user)
  end

  # Preview this email at /rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
