class SlidesController < ApplicationController

  # GET /microposts/slides/new
  def new
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  # GET /microposts/:micropost_id/slides/edit
  def edit
    @micropost = Micropost.find(params[:micropost_id])
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render action: "new" }
    end
  end

  # GET /microposts/slides/close
  def close
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end


  # GET /microposts/slides/set
  def set
    @micropost = current_user.microposts.build(micropost_params)
    if valid_params? && valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js
      end
    else
      @micropost.errors.add(:slide, "Invalid params") unless valid_params?
      @micropost.errors.add(:slide, "Please check file authority and URL") unless valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "new" }
      end
    end
  end


  # GET /microposts/:micropost_id/slides/replace
  def replace
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.attributes = micropost_params

    if valid_params? && valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "set" }
      end
    else
      @micropost.errors.add(:slide, "Invalid params") unless valid_params?
      @micropost.errors.add(:slide, "Please check file authority and URL") unless valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "new" }
      end
    end
  end


  # GET /microposts/slides/remove
  def remove
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end


  # GET /microposts/:micropost_id/slides/remove_exist
  def remove_exist
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.attributes = {file_type: nil, file_link: nil}
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render action: "remove" }
    end
  end

  
  private
    
  # Strong parameter
  def micropost_params
    params.require(:micropost).permit(:file_type, :file_link)
  end

  def valid_params?
    file_link = micropost_params[:file_link]
    if micropost_params[:file_type] == "GoogleSlides"
      file_link.present? && \
      file_link.start_with?('<iframe src="https://docs.google.com/presentation/d/')
    elsif micropost_params[:file_type] == "PowerPoint"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://onedrive.live.com/embed?resid=') && \
        file_link.end_with?('これは、<a target="_blank" href="https://office.com/webapps">Office</a> の機能を利用した、<a target="_blank" href="https://office.com">Microsoft Office</a> の埋め込み型のプレゼンテーションです。</iframe>') )
    elsif micropost_params[:file_type] == "pdf_link"
      file_link.present? && \
      ( file_link.start_with?('https://') && \
        file_link.end_with?('.pdf') )
    elsif micropost_params[:file_type] == "pdf_google"
      file_link.present? && \
      ( file_link.start_with?('https://drive.google.com/file/d/') && \
        file_link.end_with?('/view?usp=sharing') )
    end
  end

  def valid_authority?
    og = OpenGraph.new(micropost_params[:file_link], { :headers => {'User-Agent' => 'ruby'} })
    micropost_params[:file_type] == "pdf_google" && og.metadata.present?
  end

end
