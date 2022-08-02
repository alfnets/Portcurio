class TagsController < ApplicationController
  
  # GET /microposts/:micropost_id/tags/edit
  def edit
    @micropost = Micropost.find(params[:micropost_id])
    if current_user == @micropost.user
      @lock_tags = []
      @edit_tags = @micropost.tags.pluck(:name)
    else
      @lock_tags = Tag.find(@micropost.micropost_tags.where(lock_flag: true).pluck(:tag_id)).pluck(:name)
      @edit_tags = Tag.find(@micropost.micropost_tags.where(lock_flag: false).pluck(:tag_id)).pluck(:name)
    end
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end

  # PATCH /microposts/:micropost_id/tags
  def update
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.tags_update(params[:micropost][:edit_tags].split(","), current_user)
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end

end
