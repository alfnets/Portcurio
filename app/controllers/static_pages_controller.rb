class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page])
      @feedall     = Kaminari.paginate_array(Micropost.all).page(params[:page])
      @userprofile = current_user
    else
      render 'welcome'
    end
  end
  
  def about
    redirect_to 'https://alfnet.info/profile/'
  end
  
  def contact
    redirect_to 'https://alfnet.info/contact/'
  end
end
