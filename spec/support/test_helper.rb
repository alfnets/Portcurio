module TestHelper
  module SystemHelper
    def log_in(user)
      visit login_path
 
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end

  module RequestHelper
    def log_in(user)
      post login_path, params: { session: { email:    user.email,
                                            password: user.password } }
    end

    def is_logged_in?
      !session[:user_id].nil?
    end

    def log_out
      session[:user_id] = nil
    end
  end
end