class LinksController < ApplicationController
  def show
    @userprofile = current_user
    @last_link = Link.last
    if @last_link
      @org_markdown = @last_link.markdown
    else
      @org_markdown = "Let's create!"
    end
  end

  def edit
    @userprofile = current_user
    @last_link = Link.last
    if @last_link
      @org_markdown = @last_link.markdown
    else
      @org_markdown = "Let's create!"
    end
  end

  def create
    @userprofile = current_user
    markdown = params[:markdown]
    current_user.links.create(markdown: markdown)
    flash[:success] = "The link page saved!"
    redirect_to edit_links_path
  end

end
