class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :show]
  before_action :correct_user, only: :destroy
 
  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.tags_save(tag_params)
    @micropost.image.attach(params[:micropost][:image])
    begin
      if Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a').present?
        @micropost.links = Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a')[:href]
      end
    rescue
    end
    if @micropost.save
      @porc = @micropost.porcs.create(user: current_user)
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
      @userprofile = current_user
      @feed_items = current_user.feed.page(params[:page])
      @feedall     = Kaminari.paginate_array(Micropost.all).page(params[:page])
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
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @title = "Search Result for Micropost"
      @feedall = Kaminari.paginate_array(@result_search_microposts.includes(:tags)).page(params[:page])
    elsif params[:school_type]
      @selected_school_type = params[:school_type]
      @selected_subject     = params[:subject]
      @click_tags  = nil  # 後で機能を追加すること
      @title = "#{params[:school_type]} #{params[:subject]}"
      @feedall = Kaminari.paginate_array(tag_filter([@selected_school_type, @selected_subject]).includes(:tags)).page(params[:page])
    elsif params[:tags]
      @selected_school_type = nil
      @selected_subject     = nil
      @click_tags  = params[:tags].split(",")
      @title = "Filter Result for Micropost"
      @feedall = Kaminari.paginate_array(tag_filter(@click_tags).includes(:tags)).page(params[:page])
    else
      @title = "All users feed"
      @feedall = Kaminari.paginate_array(Micropost.all.includes(:tags)).page(params[:page])
    end
    @tags = Tag.where(category: nil)  # タグの一覧表示
    @userprofile = current_user
  end
  

  # GET /microposts/:id
  def show
    @feedmicropost = Micropost.find(params[:id])
    @userprofile = @feedmicropost.user
    @comments = @feedmicropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
  end
 
  
  # GET /microposts/get_selected_school_type
  def get_selected_school_type
    @selected_school_type = params[:selected_school_type]
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end

  private
    
    # Strong parameter
    def micropost_params
      params.require(:micropost).permit(:content, :image, :file_type, :file_link)
    end

    def tag_params
      a = params.require(:micropost).permit(:tags)
      if a.present? then a[:tags].split(",") end
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    
    def tag_filter(tags)
      result = Tag.find_by(name: tags[0]).microposts
      tags.each do |tag|
        result.merge!(Tag.find_by(name: tag).microposts) if tag.present?
      end
      result
    end
end
