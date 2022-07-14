class SessionsController < ApplicationController
  
  # GET /login
  def new
    # x @session = Session.new
    # o scope: :session + url: login_path
  end
  
  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_url
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email or password'
      if request.referer == root_url
        render 'static_pages/welcome', layout: 'welcome'
      else
        render 'new'
      end
    end
  end
  
  # POST /easylogin/:id
  def easylogin
    user = User.find(params[:id])
    log_in user
    redirect_back_or root_url
  end
  
  # GET /line
  def line
  end
  
  # POST /line
  def line_connection
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      nonce = SecureRandom.urlsafe_base64
      user.update(linenonce: nonce)
      redirect_to "https://access.line.me/dialog/bot/accountLink?linkToken=#{params[:linkToken]}&nonce=#{nonce}"
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'line'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
