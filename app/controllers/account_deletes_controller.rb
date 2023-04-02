class AccountDeletesController < ApplicationController
  before_action :correct_user, only: [:update]
  before_action :logged_in_user, only: [:update]

  # PATCH /account_deletes/:id (+ params)
  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:current_password])
      @user.create_delete_digest
      @user.send_delete_email
      flash[:info] = "Please check your email to delete your account."
      redirect_to delete_user_path(@user)
    else
      flash.now[:danger] = 'Invalid password.'
      render 'users/delete'
    end
  end

  # GET account_deletes/:id/exec
  def exec
    @user = User.find_by(email: params[:email])
    if @user.authenticated?(:delete, params[:id])
      @user.send_delete_comp_email
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to root_url
    else
      flash[:danger]  = "Invalid deletion link"
      redirect_to root_url
    end
  end


  private

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
