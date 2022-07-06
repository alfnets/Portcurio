class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :show]
  before_action :correct_user, only: :destroy
 
  # include Kaminari::Helpers::UrlHelper  

  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    begin
      if Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a').present?
        @micropost.links = Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a')[:href]
      end
    rescue
    end
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url    # => static_pages#home
      # respond_to do |format|
      #   format.html { redirect_to request.referer || root_url }
      #   format.js
      # end
      users = current_user.subscribers
      users.each do |user|
        notification = current_user.active_notifications.build(
          notificable: @micropost,
          notified_id: user.id,
          # micropost_id: @micropost.id
        )
        notification.save if notification.valid?
        if notification.notified.lineuid
          host_name = ENV.fetch("HOST", nil)
          url = "https://#{host_name}/microposts/#{notification.notificable_id}"
          unless notification.notificable.image.attached?
            text = "#{notification.notifier.name}さんが新しい投稿をしました\n#{url}\n\n#{notification.notificable.content}"
          else
            text = "#{notification.notifier.name}さんが新しい投稿をしました\n#{url}\n\n#{notification.notificable.content} (この投稿には画像が添付されています)"
          end
          message = {
            type: 'text',
            text: text
          }
          client.push_message(notification.notified.lineuid, message)
        end
      end

    else
      @feed_items = current_user.feed.page(params[:page])
      render 'static_pages/home'
    end
  end
  
  
  # DELETE /microposts/:id
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referer || root_url
  end
  

  # GET /microposts
  def index
    @feedall = Kaminari.paginate_array(Micropost.all).page(params[:page])
    @userprofile = current_user
  end
  

  # GET /microposts/:id
  def show
    @feedmicropost = Micropost.find(params[:id])
    @userprofile = @feedmicropost.user
    @comments = @feedmicropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
  end
  

  private
    
    # Strong parameter
    def micropost_params
      params.require(:micropost).permit(:content, :image, :file_type, :file_link)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    
end
