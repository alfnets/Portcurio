class StaticPagesController < ApplicationController
  require 'json'

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page]).per(12)
      @all_feed_items = current_user.all_feed.page(params[:page]).per(12)
      @all_microposts = Kaminari.paginate_array(Micropost.all).page(params[:page])
    else
      # render 'welcome', layout: 'welcome'
      @props = JSON.generate(
        {
          logo_url: ActionController::Base.helpers.asset_path("logo_portcurio.png")
        }
      )

      @entrypoint = "welcome"
      render layout: false, template: "react_welcome"
    end
  end
  
  def about
    redirect_to 'https://alfnets.info/web-dev05/'
  end
  
  def contact
    redirect_to 'https://alfnets.info/contact/'
  end
end
