class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :new, :remove_exist_image, :remove_image]
  before_action :correct_user,   only: :destroy

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
 
  # POST /microposts
  def create
    @micropost = params[:micropost][:file_type].present? ? current_user.microposts.build(micropost_params.merge!(file_type_id: FileType.find_by(value: params[:micropost][:file_type]).id)) : current_user.microposts.build(micropost_params)
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
      @feed_items = current_user.feed.page(params[:page]).per(12)
      @all_microposts     = Kaminari.paginate_array(Micropost.all).page(params[:page]).per(12)
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
    @micropost.attributes = params[:micropost][:file_type].present? ? micropost_params.merge(file_type_id: FileType.find_by(value: params[:micropost][:file_type]).id) : micropost_params
    begin
      if Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a').present?
        @micropost.links = Nokogiri::HTML(Rinku.auto_link(@micropost.content)).at_css('a')[:href]
      end
    rescue
    end
    if @micropost.save
      @micropost.image.purge if params[:micropost][:image_delete] === '1'
      flash[:success] = "Micropost updated!"
      redirect_to request.referer    # => static_pages#home
      # respond_to do |format|
      #   format.html { redirect_to request.referer || root_url }
      #   format.js
      # end
    else
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
      @material_filter = true
      @micropost = Micropost.new(educational_material: @material_filter)
      @title = "Search Result"
      @keywords = params[:keywords].gsub("　"," ").split
      result_microposts = search_microposts(@keywords)
      @selected_tags    = @keywords.join(",")
      @all_microposts = Kaminari.paginate_array(result_microposts.includes(:tags)).page(params[:page]).per(12)
    else
      @material_filter = params[:micropost][:educational_material].to_boolean
      @micropost = Micropost.new(school_type: params[:micropost][:school_type], subject: params[:micropost][:subject], educational_material: @material_filter)
      if params[:micropost][:tags].present?
        @selected_tags    = params[:micropost][:tags]
        result_microposts = search_microposts(@selected_tags.split(","), @micropost.educational_material)
        @title = @selected_tags.split(",").count === 1 ? "##{@selected_tags}" : "Search Result"
        @all_microposts = Kaminari.paginate_array(result_microposts.includes(:tags)).page(params[:page]).per(12)
      else
        @selected_tags = ""
        if logged_in?
          if @material_filter
            result_microposts = Micropost.where(educational_material: true).merge(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)))
          else
            result_microposts = Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id))
          end
        else
          if @material_filter
            result_microposts = Micropost.where(educational_material: true).merge(Micropost.where(publishing: "public"))
          else
            result_microposts = Micropost.where(publishing: "public")
          end
        end
        @title = "All users feed"
        @all_microposts = Kaminari.paginate_array(result_microposts.includes(:tags)).page(params[:page]).per(12)
      end
    end
    @tags = Tag.where(category: nil).order(created_at: :desc).limit(8)  # タグの一覧表示
  end
  

  # GET /microposts/:id
  def show
    @micropost = Micropost.find(params[:id])
    
    redirect_to root_url if @micropost.publishing == 'private' && @micropost.user != current_user
    @comments = @micropost.comments.where(parent_id: nil).unscope(:order).order(updated_at: :desc)
  end
 
  
  # GET /microposts/get_selected_school_type
  def get_selected_school_type
    @selected_school_type = params[:selected_school_type]
    respond_to do |format|
      format.js
    end
  end


  # GET /microposts/add_search_tag
  def add_search_tag
    @tag = params[:tag]
    respond_to do |format|
      format.js
    end
  end


  # GET /microposts/remove_image
  def remove_image
    respond_to do |format|
      format.js
    end
  end


  # GET /microposts/:id/remove_exist_image
  def remove_exist_image
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.js { render "remove_image" }
    end
  end


  private
  
    def record_not_found
      redirect_to root_path
    end

    # Strong parameter
    def micropost_params
      params.require(:micropost).permit(:title, :content, :image, :file_link, :publishing, :educational_material)
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
      result = Micropost.where(educational_material: true).ransack(tags_name_eq: tags[0]).result
      return nil unless result
      tags.each do |tag|
        result = result & Micropost.where(educational_material: true).ransack(tags_name_eq: tag).result
      end
      if logged_in?
        Micropost.where(id: result.map(&:id)).merge(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)))
      else
        Micropost.where(id: result.map(&:id)).merge(Micropost.where(publishing: "public"))
      end
    end
end
