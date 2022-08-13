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
    if valid_params?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js
      end
    else
      @micropost.errors.add(:slide, "Invalid params")
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

    if valid_params?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "set" }
      end
    else
      @micropost.errors.add(:slide, "Invalid params")
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
    if micropost_params[:file_type] == "GoogleSlides"
      micropost_params[:file_link].present? && \
      micropost_params[:file_link].start_with?('<iframe src="https://docs.google.com/presentation/d/')
    elsif micropost_params[:file_type] == "PowerPoint"
      micropost_params[:file_link].present? && \
      ( micropost_params[:file_link].start_with?('<iframe src="https://onedrive.live.com/embed?resid=') && \
        micropost_params[:file_link].end_with?('これは、<a target="_blank" href="https://office.com/webapps">Office</a> の機能を利用した、<a target="_blank" href="https://office.com">Microsoft Office</a> の埋め込み型のプレゼンテーションです。</iframe>') )
    end
  end

end
