class TagsController < ApplicationController
  
  # GET /microposts/:micropost_id/tags/edit
  def edit
    @micropost = Micropost.find(params[:micropost_id])
    # 投稿者だったら全部、非投稿者だったら投稿者のIDのもの以外
    @micropost_tags = @micropost.tags.pluck(:name).join(",")
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end

  # PATCH /microposts/:micropost_id/tags
  def update
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.tags_update(tag_params)
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end

  private

  def tag_params
    a = []
    if params[:micropost][:tags].present?
      tags_str = params[:micropost][:tags].delete(' 　')
      a = tags_str.split(",")
    end
  end
  
end
