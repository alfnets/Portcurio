class PorcsController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  # POST /microposts/:micropost_id/porcs
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @porc = @micropost.porcs.build(user: current_user)
    @porc.save

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  # DELETE /microposts/:micropost_id/porcs/:id
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @porc.destroy
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  private
    
  def correct_user
    @porc = current_user.porcs.find_by(id: params[:id])
    redirect_to root_url if @porc.nil?
  end
end
