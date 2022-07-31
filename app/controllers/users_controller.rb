class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :setting, :edit, :update, :destroy, :show,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :set_q,          only: :index
  

  # GET /users
  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @title = "Search Result for User"
    else
      @title = "All users"
    end
    @userprofile = current_user
    @users = @q.result.page(params[:page])
  end
  
  # GET /users/:id
  def show
    @userprofile = User.find(params[:id])

    redirect_to root_url and return unless @userprofile.activated?

    # Microposts
    @microposts = @userprofile.microposts.page(params[:page]).per(20)
    
    # Comments & likes
    @comments_and_likes = Notification.where(
      notifier_id: @userprofile.id
    ).where.not(
      notified_id: @userprofile.id
    ).where.not(
      notificable_type: 'Relationship'
    ).where.not(
      notificable_type: 'Micropost'
    ).page(params[:page]).per(10)
    
    @path = request.fullpath
    # debugger
  
  end
  
  # GET /users/new
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end
  
  # POST /users (+ params)
  def create
    # (user + given params).save
    # User.create(params[:user]) マスアサイメント脆弱性になる
      # ex.) POST + params[:user][:admin] = true
    # => name, email, pass/confirmation のみに限定するチェック機構である(user_params)を作って使う
    @user = User.new(user_params) 
    if @user.save #  == true
      # Success (valid params)
      # GET "/users/#{@user.id}"
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # redirect_to user_path(@user)
      # redirect_to user_path(@user.id)
      # redirect_to user_path(1)
                  # => /users/1
      
      # メール認証の部分
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
      # メール認証をせず、アクティベート
      # @user.update_attribute(:activated,     true)
      # @user.update_attribute(:activated_at,  Time.zone.now)
      # log_in @user
      # flash[:success] = "Account activated!"
      # redirect_to root_url
      
    else
      # Failure (not valid params)
      # 入力したemailを使ったユーザーが既にいるか確認
      @org_user = User.find_by(email: user_params[:email])
      if @org_user
        # 既にいるユーザーがアクティベート済みでエラーが1つだけ（"Email has already been taken"）であることを確認
        if !@org_user.activated? && @user.errors.count == 1 && @user.errors.full_messages.include?("Email has already been taken")
          @org_user.update(user_params)
          @org_user.reset_activation_digest
          @org_user.send_activation_email
          flash[:info] = "Resend the email to activate your account. Please check your email."
          redirect_to root_path
        else
          if !@org_user.activated? && @user.errors.full_messages.include?("Email has already been taken")
            @user.errors.messages.delete(:email)
          end
          render 'new'
        end
      else
        render 'new'
      end
    end
  end
  
  # GET /users/setting
  def setting
    redirect_to edit_user_path(current_user)
  end
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.html.erb
  end
  
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    
    if @user.authenticate(params[:user][:current_password])
      if params[:user][:line_connection_delete] === '1'
        lineuid = @user.lineuid
        user_params.merge!(params[:user][:lineuid] = nil)
      end
      if @user.update(user_params)
        # 更新に成功した場合を扱う
        flash[:success] = "Profile updated"
        redirect_to edit_user_path(@user)
      else
        # @users.errors # <== ここにデータが入っている
        render 'edit'
      end
      if params[:user][:line_connection_delete] === '1'
        client.unlink_user_rich_menu(lineuid)
        message = {
          type: 'text',
          text: "通知連携が解除されました。再度、通知連携をしたい場合には画面下部の「通知の認証をする」をタップしてください。"
        }
        client.push_message(lineuid, message)
      end
    else
      flash.now[:danger] = 'Invalid password' unless @user.authenticate(params[:user][:current_password])
      render 'edit'
    end
  end
  
  # GET /users/:id/delete
  def delete
    @user = User.find(params[:id])
  end

  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  # GET /users/:id/following
  def following
    @title = "Following"
    @userprofile  = User.find(params[:id])
    @users = @userprofile.following.page(params[:page]).per(10)
    render 'show_follow'
  end

  # GET /users/:id/followers
  def followers
    @title = "Followers"
    @userprofile  = User.find(params[:id])
    @users = @userprofile.followers.page(params[:page]).per(10)
    render 'show_follow'
  end
  
  # GET /users/:id/subscribing
  def subscribing
    @title = "Subscribing"
    @userprofile = User.find(params[:id])
    @users = @userprofile.subscribing.page(params[:page]).per(10)
    render 'show_follow'
  end
  
  # GET /users/:id/portcurio
  def portcurio
    if params[:micropost] && params[:micropost][:tags].present?
      @selected_school_type = params[:micropost][:school_type]
      @selected_subject     = params[:micropost][:subject]
      @selected_tags        = params[:micropost][:tags].delete(' 　')
      result_microposts = search_microposts(@selected_tags.split(","))
      @portcurio = Kaminari.paginate_array(result_microposts.joins(:porcs).where(porcs: { user: current_user }).includes(:tags)).page(params[:page])
    else
      @selected_tags = ""
      @portcurio = Micropost.joins(:porcs).where(porcs: { user: current_user }).page(params[:page])
    end
    @tags = Tag.where(category: nil).order(created_at: :desc).limit(8)  # タグの一覧表示
    @userprofile = current_user
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :lineuid)
    end

    def search_params
      params.require(:q).permit(:name_cont)
    end
    
    # beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # 検索結果の取得
    def set_q
      if params[:q]
        @q = User.ransack(search_params, activated_true: true)
      else
        @q = User.ransack(activated_true: true)
      end
    end
end