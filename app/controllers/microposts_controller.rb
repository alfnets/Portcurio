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
      @feedall = Kaminari.paginate_array(@result_search_microposts).page(params[:page])
    elsif params[:subject] || params[:tag]
      if params[:subject]
        @click_tag = params[:subject]
        @school_type = params[:school_type]
        @title = @school_type + " " + @click_tag
      elsif params[:tag]
        @click_tag = params[:tag]
        @school_type = nil
        @title = "#" + @click_tag
      end
      @feedall = Kaminari.paginate_array(Micropost.tagged_with("#{@click_tag}, #{@school_type}")).page(params[:page])
      @primary_subjects            = Micropost.tags_on(:primary_subjects)             # 教科タグの一覧表示
      @secondary_subjects          = Micropost.tags_on(:secondary_subjects)           # 教科タグの一覧表示
      @senior_common_subjects      = Micropost.tags_on(:senior_common_subjects)       # 教科タグの一覧表示
      @senior_specialized_subjects = Micropost.tags_on(:senior_specialized_subjects)  # 教科タグの一覧表示
      @tags                        = Micropost.tag_counts_on(:tags).most_used(20)  # タグの一覧表示
    else
      @title = "All users feed"
      @feedall = Kaminari.paginate_array(Micropost.all).page(params[:page])
      @primary_subjects             = Micropost.tags_on(:primary_subjects)            # 教科タグの一覧表示
      @secondary_subjects           = Micropost.tags_on(:secondary_subjects)          # 教科タグの一覧表示
      @senior_common_subjects       = Micropost.tags_on(:senior_common_subjects)      # 教科タグの一覧表示
      @senior_specialized_subjects  = Micropost.tags_on(:senior_specialized_subjects)  # 教科タグの一覧表示
      @tags                         = Micropost.tag_counts_on(:tags).most_used(20)  # タグの一覧表示
    end    
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
      params.require(:micropost).permit(:content, :image, :file_type, :file_link, :tag_list, :school_type_list, :subject_list)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    
end
