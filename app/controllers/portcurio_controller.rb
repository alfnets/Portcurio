class PortcurioController < ApplicationController
  # GET /portcurio
  def index
    @material_filter = params[:micropost][:educational_material].to_boolean
    @micropost = Micropost.new(school_type: params[:micropost][:school_type], subject: params[:micropost][:subject], educational_material: @material_filter)
    
    if params[:micropost][:tags].present?
      @selected_tags    = params[:micropost][:tags]
      result_microposts = search_microposts(@selected_tags.split(","), @micropost.educational_material)
    else
      @selected_tags = ""
      if @material_filter
        result_microposts = Micropost.where(educational_material: true).merge(Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id)))
      else
        result_microposts = Micropost.where(publishing: "public").or(Micropost.where(user_id: current_user.id))
      end
    end

    @portcurio = Kaminari.paginate_array(result_microposts.joins(:porcs).where(porcs: { user: current_user }).includes(:tags)).page(params[:page]).per(12)

    @tags = Tag.where(category: nil).order(created_at: :desc).limit(8)  # タグの一覧表示
  end
end
