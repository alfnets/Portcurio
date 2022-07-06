class SlidesController < ApplicationController

  # GET /microposts/slides/new
  def new
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
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


  # POST /microposts/slides
  def create
    if valid_params?
      @micropost = current_user.microposts.build(micropost_params)
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js
      end
    else
      @micropost = current_user.microposts.build
      @micropost.errors.add(:slide, "Invalid params")
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render :action => "new" }
      end
    end
  end


  # DELETE /microposts/slides
  def destroy
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
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
