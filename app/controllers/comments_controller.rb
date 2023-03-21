class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  # POST /microposts/:micropost_id/comments
  def create
    @userprofile = User.find(params[:userprofile_id])
    
    $mention_ids = nil unless params[:parent_id]

    # if $mentions
    #   mention_ids = []
    #   $mentions.each do |mention|
    #     mention_ids.push(mention.id)
    #   end
    # end
    
    @comment = current_user.comments.build(comment_params.merge(
      micropost_id: params[:micropost_id]).merge(
      parent_id: params[:parent_id]).merge(
      mention_ids: $mention_ids)
    )

    @feedmicropost = Micropost.find(params[:micropost_id])
    unless @comment.parent
      # 親コメントがない場合
      $mention_ids = [@comment.user_id] unless current_user.id === @comment.user_id
    else
      # 親コメントがある場合
      $mentions_ids = [@comment.parent.user_id] unless current_user.id === @comment.parent.user_id
    end


    if @comment.save
      micropost = Micropost.find(@comment.micropost_id)
      
      unless @comment.parent_id
      # 親コメントがない場合
        notification = current_user.active_notifications.build(
          notificable: @comment,
          notified_id: micropost.user_id,
          # micropost_id: micropost.id
        )
        if notification.valid?
          notification.check if notification.notified_id === notification.notifier_id
          notification.save
          if notification.notified.lineuid && notification.notified_id != notification.notifier_id
            host_name = ENV.fetch("HOST", nil)
            url = "https://#{host_name}/microposts/#{notification.notificable.micropost_id}"
            message = {
              type: 'text',
              text: "#{notification.notifier.name}さんがあなたの投稿にコメントしました\n#{url}\n\n#{notification.notificable.content}"
            }
            client.push_message(notification.notified.lineuid, message)
          end
        end
      else
      # 親コメントがある場合
        $mention_ids.each do |mention_id|
          notification = current_user.active_notifications.build(
            notificable: @comment,
            notified_id: mention_id,
            # micropost_id: micropost.id
          )
          if notification.valid?
            notification.check if notification.notified_id === notification.notifier_id
            notification.save
            if notification.notified.lineuid && notification.notified_id != notification.notifier_id
              host_name = ENV.fetch("HOST", nil)
              url = "https://#{host_name}/microposts/#{notification.notificable.micropost_id}"
              message = {
                type: 'text',
                text: "#{notification.notifier.name}さんがあなたをメンションしました\n#{url}\n\n#{notification.notificable.content}"
              }
              client.push_message(notification.notified.lineuid, message)
            end
          end
        end
        @comment.parent.touch   # 親コメの日時の更新（アゲ）
      end
    else
      @errors_comment = @comment
    end
    
    unless @comment.parent
      # 親コメントがない場合
      @comments = @feedmicropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
    else
      # 親コメントがある場合
      @replies = @comment.parent.replies.unscope(:order).order(created_at: :asc)
      @comment = @comment.parent # 'comments/show.js.erb'の分岐・レンダリング用
    end

    if current_user.id === @comment.user_id
      $mention_ids = []
    else
      $mention_ids = [@comment.user_id]
    end

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render 'comments/show.js.erb' }
    end
  end
  
  
  # DELETE /microposts/:micropost_id/comments/:id
  def destroy
    @userprofile = User.find(params[:userprofile_id])
    
    @feedmicropost = Micropost.find(params[:micropost_id])
    
    @comment.destroy
    
    unless @comment.parent
      # 親コメントがない
      @comments = @feedmicropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
      $mention_ids = [@comment.user_id] unless current_user.id === @comment.user_id
    else
      # 親コメントがある
      @replies = @comment.parent.replies.unscope(:order).order(created_at: :asc)
      $mention_ids = [@comment.parent.user_id] unless current_user.id === @comment.parent.user_id
    end
    
    if @comment.mention_ids
      ids = @comment.mention_ids.delete("[] ").split(',').map{|n| n.to_i}
      ids.each do |id|
        notification = current_user.active_notifications.find_by(
          notificable: @comment,
          notified_id: id
        )
        notification.destroy if notification.present?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render 'comments/show.js.erb' }
    end
  end


  # GET /comments/:id
  # GET /microposts/:micropost_id/comments/:id
  def show
    @userprofile = User.find(params[:userprofile_id])

    resource = request.path.split('/')[1]
    if resource === "comments"
      @feedmicropost = Micropost.find(params[:id])
      @comments = @feedmicropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
    elsif resource === "microposts"
      @feedmicropost = Micropost.find(params[:micropost_id])
      @comment = Comment.find(params[:id])
      unless @comment.parent
        # 親コメントがない場合
        if current_user.id === @comment.user_id
          $mention_ids = []
        else
          $mention_ids = [@comment.user_id]
        end
        @replies = @comment.replies.unscope(:order).order(created_at: :asc)
      else
        # 親コメントがある場合
        $mention_ids.push(@comment.user_id) unless current_user.id === @comment.user_id
        $mention_ids.uniq! if $mention_ids
        @replies = @comment.parent.replies.unscope(:order).order(created_at: :asc)
      end

    end

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
  
  # GET /comments/:id/close 
  # GET /microposts/:micropost_id/comments/:id/close
  def close
    logger.debug("if文の中に入りました")
    @userprofile = User.find(params[:userprofile_id])
    
    resource = request.path.split('/')[1]
    if resource === "comments"
      @feedmicropost = Micropost.find(params[:id])
      @comments = @feedmicropost.comments.where(parent_id: nil).order(created_at: :asc)
    else
      @feedmicropost = Micropost.find(params[:micropost_id])
      @comment = Comment.find(params[:id])
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end


  # GET /microposts/:micropost_id/comments/:id/mention_delete
  def mention_delete
    @userprofile = User.find(params[:userprofile_id])
    @feedmicropost = Micropost.find(params[:micropost_id])
    @comment = Comment.find(params[:id])
    @replies = @comment.replies.unscope(:order).order(created_at: :asc)
    $mention_ids.delete(params[:user_id].to_i)
    
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render 'comments/mention_delete.js.erb' }
    end
  end

  private
    
    # Strong parameter
    def comment_params
      params.require(:comment).permit(:content)
    end
    
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end

end
