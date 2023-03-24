class LikesController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  # POST /[likeable]/:[likeable]_id/likes
  def create
    resource, id = request.path.split('/')[1, 2]
    # /microposts/2/likes => ["", "microposts", "2", "likes"]
    # resource, id => ["microposts", "2"]
    
    @likeable = resource.singularize.classify.constantize.find(id)
    # .singularize  : "microposts" => "micropost" (単数化)
    # .classify     : "micropost" => "Micropost" (モデルクラス名に変換)
    # .constantize  : "Micropost" => Micropost (定数化)
    # @likeable = Micropost.find(2)
    
    @like = current_user.likes.build(likeable: @likeable)
    # 変更前
    # @like = current_user.likes.build(micropost_id: params[:micropost_id])
    # # @like = Like.new(
    # #   user_id: current_user.id,
    # #   micropost_id: params[:micropost_id]
    # # )
    if @like.save
      @likeable.touch if @like.likeable_type === "Comment" && @likeable.parent_id.nil?  # 親コメントにいいね！がついたらアゲ
      
      # micropost_id = @like.micropost.id
      notification = current_user.active_notifications.build(
        notificable: @like,
        notified_id: @like.likeable.user_id,
        # micropost_id: micropost_id
      )
      if notification.valid?
        notification.check if notification.notified_id === notification.notifier_id
        notification.save
        if notification.notified.lineuid && notification.notified_id != notification.notifier_id
          host_name = ENV.fetch("HOST", nil)
          if notification.notificable.likeable_type === "Micropost"
            url = "https://#{host_name}/microposts/#{notification.notificable.likeable_id}"
          elsif notification.notificable.likeable_type === "Comment"
            url = "https://#{host_name}/microposts/#{notification.notificable.likeable.micropost_id}"
          end
          message = {
            type: 'text',
            text: "$ #{notification.notifier.name}さんにいいね！されました\n#{url}",
            emojis: [
              {
                index: 0,
                productId: "5ac21e6c040ab15980c9b444",
                emojiId: "002"
              }
            ]
          }
          client.push_message(notification.notified.lineuid, message)
        end
      end
    end
    
    # @feedmicropost = @like.micropost
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
  # DELETE /[likeable]/:[likeable]_id/likes/:id
  def destroy
    # 変更前
    # # @like = current_user.likes.find_by(micropost_id: params[:id])
    # # @like = Like.find_by(
    # #   user_id: current_user.id,
    # #   micropost_id: params[:id]
    # # )
    # @feedmicropost = @like.micropost
    notification = current_user.active_notifications.find_by(
      notificable: @like,
      notified_id: @like.likeable.user_id
    )
    notification.destroy if notification.present?
    @like.destroy
    resource, id = request.path.split('/')[1, 2]
    @likeable = resource.singularize.classify.constantize.find(id)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
  
  # Likeした人を表示する
  # GET /likes (+ params) => /[likeable]/:[likeable]_id/like
  def show
    resource, id = request.path.split('/')[1, 2]
    @likeable = resource.singularize.classify.constantize.find(id)
    # @feedmicropost = Micropost.find(params[:micropost_id])
    @users = @likeable.like_users
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
  
  # Likeした人を表示していた画面を閉じる
  # GET /likes/:id/close => /[likeable]/:[likeable]_id/likes/close
  def close
    resource, id = request.path.split('/')[1, 2]
    @likeable = resource.singularize.classify.constantize.find(id)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  private
    
    def correct_user
      @like = current_user.likes.find_by(id: params[:id])
      redirect_to root_url if @like.nil?
    end
end