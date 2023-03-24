class FilesController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :set, :replace, :remove, :remove_exist]

  # GET /microposts/files/new
  def new
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  # GET /microposts/:micropost_id/files/edit
  def edit
    @micropost = Micropost.find(params[:micropost_id])
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render action: "new" }
    end
  end

  # GET /microposts/files/close
  def close
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end


  # GET /microposts/files/set
  def set
    file_type_id = params[:micropost][:file_type].present? ? FileType.find_by(value: params[:micropost][:file_type]).id : nil
    @micropost = current_user.microposts.build(file_type_id: file_type_id, file_link: params[:micropost][:file_link])
    if valid_params? && valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js
      end
    else
      unless valid_params?
        @micropost.errors.add(:file, "Invalid params")
      else
        @micropost.errors.add(:file, "Please check file authority and URL")
      end
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "new" }
      end
    end
  end


  # GET /microposts/:micropost_id/files/replace
  def replace
    @micropost = Micropost.find(params[:micropost_id])
    file_type_id = params[:micropost][:file_type].present? ? FileType.find_by(value: params[:micropost][:file_type]).id : nil
    @micropost.attributes = { file_type_id: file_type_id, file_link: params[:micropost][:file_link] }

    if valid_params? && valid_authority?
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "set" }
      end
    else
      unless valid_params?
        @micropost.errors.add(:file, "Invalid params")
      else
        @micropost.errors.add(:file, "Please check file authority and URL")
      end
      respond_to do |format|
        format.html { redirect_to request.referer || root_url }
        format.js { render action: "new" }
      end
    end
  end


  # GET /microposts/files/remove
  def remove
    @micropost = current_user.microposts.build
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end


  # GET /microposts/:micropost_id/files/remove_exist
  def remove_exist
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.attributes = {file_type_id: nil, file_link: nil}
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js { render action: "remove" }
    end
  end

  
  private

  def valid_params?
    file_type = params[:micropost][:file_type]
    file_link = params[:micropost][:file_link]
    if file_type == "GoogleSlides"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://docs.google.com/presentation/d/') && \
        file_link.end_with?('</iframe>') )
    elsif file_type == "GoogleDocs"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://docs.google.com/document/d/e/') && \
        file_link.end_with?('</iframe>') )
    elsif file_type == "GoogleSheets"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://docs.google.com/spreadsheets/d/e/') && \
        file_link.end_with?('</iframe>') )
    elsif file_type == "GoogleForms"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://docs.google.com/forms/d/e/') && \
        file_link.end_with?('</iframe>') )
    elsif file_type == "PowerPoint"
      file_link.present? && \
      ( file_link.start_with?('<iframe src="https://onedrive.live.com/embed?') && \
        file_link.end_with?('</iframe>') )
    elsif file_type == "PDF_link"
      file_link.present? && \
      ( file_link.start_with?('https://') && \
        file_link.end_with?('.pdf') )
    elsif file_type == "GooglePDF"
      file_link.present? && \
      ( file_link.start_with?('https://drive.google.com/file/d/') && \
        file_link.end_with?('/view?usp=sharing') )
    end
  end

  def valid_authority?
    file_type = params[:micropost][:file_type]
    file_link = params[:micropost][:file_link]
    if file_type == "GooglePDF"
      og = OpenGraph.new(file_link, { :headers => {'User-Agent' => 'ruby'} })
      file_type == "GooglePDF" && og.metadata.present?
    else
      return true
    end
  end

end
