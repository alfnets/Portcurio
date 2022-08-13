class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :show]
  before_action :correct_user,   only: :destroy
 
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
      @micropost.tags_save(tag_params, current_user) if tag_params
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
        notification.save if notification.valid? && @micropost.publishing == "public"
        if notification.notified.lineuid && @micropost.publishing == "public"
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

  # GET /microposts/:id/edit
  def edit
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # PATCH /microposts/:id
  def update
    @micropost = Micropost.find(params[:id])
    # @micropost.image.purge if !micropost_params[:image].present?
    @micropost.attributes = micropost_params
    # @micropost.image.attach(params[:micropost][:image])
    begin
      if Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a').present?
        @micropost.links = Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a')[:href]
      end
    rescue
    end
    if @micropost.save
      flash[:success] = "Micropost updated!"
      redirect_to request.referer    # => static_pages#home
      # respond_to do |format|
      #   format.html { redirect_to request.referer || root_url }
      #   format.js
      # end
    else
      @userprofile = current_user
      respond_to do |format|
        format.js { render action: "edit" }
      end
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
    if params[:keywords]
      @micropost = Micropost.new
      @title = "Search Result"
      @keywords = params[:keywords].gsub("　"," ").split
      result_microposts = search_microposts(@keywords)
      @selected_tags    = @keywords.join(",")
      @feedall = Kaminari.paginate_array(result_microposts.includes(:tags)).page(params[:page])
    elsif params[:micropost] && (params[:micropost][:tags].present? || params[:micropost][:educational_material].to_boolean)
      @micropost = Micropost.new(school_type: params[:micropost][:school_type], subject: params[:micropost][:subject], educational_material: params[:micropost][:educational_material].to_boolean)
      if params[:micropost][:tags].present?
        @selected_tags    = params[:micropost][:tags]
        result_microposts = search_microposts(@selected_tags.split(","), @micropost.educational_material)
      else
        result_microposts = Micropost.where(educational_material: true).merge(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)))
      end
      if result_microposts
        @title = "Search Result"
        @feedall = Kaminari.paginate_array(result_microposts.includes(:tags)).page(params[:page])
      else
        @title = "No Result"
        @feedall = Kaminari.paginate_array(Micropost.all.includes(:tags)).page(params[:page])
      end
    elsif params[:click_tag]
      @micropost = Micropost.new
      @selected_tags = [params[:click_tag]]
      tag_microposts = tag_filter(@selected_tags)
      @title = "##{params[:click_tag]}"
      @feedall = Kaminari.paginate_array(tag_microposts.includes(:tags)).page(params[:page])
    else
      @micropost = Micropost.new
      @selected_tags = ""
      @title = "All users feed"
      @feedall = Kaminari.paginate_array(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)).includes(:tags)).page(params[:page])
    end
    @tags = Tag.where(category: nil).order(created_at: :desc).limit(8)  # タグの一覧表示
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


  # GET /microposts/add_search_tag
  def add_search_tag
    @tag = params[:tag]
    @userprofile = current_user
    respond_to do |format|
      format.js
    end
  end


  private
    
    # Strong parameter
    def micropost_params
      params.require(:micropost).permit(:content, :image, :file_type, :file_link, :publishing, :educational_material)
    end

    def tag_params
      a = []
      if params[:micropost][:tags].present?
        tags_str = params[:micropost][:tags].delete(' 　')
        a = tags_str.split(",")
      end
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    
    def tag_filter(tags)
      tags.reject!(&:blank?)
      result = Micropost.ransack(tags_name_eq: tags[0]).result
      return nil unless result
      tags.each do |tag|
        result = result & Micropost.ransack(tags_name_eq: tag).result
      end
      Micropost.where(id: result.map(&:id)).merge(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)))
    end
end
