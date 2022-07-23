class LinksController < ApplicationController
  def show
    if Link.last
      @org_markdown = Link.last.markdown
    else
      @org_markdown = "Let's create!"
    end
  end

  def edit
    if Link.last
      @org_markdown = Link.last.markdown
    else
      @org_markdown = "Let's create!"
    end
  end

  def create
    markdown = params[:markdown].html_safe
    current_user.links.create(markdown: markdown)
    flash[:success] = "The link page saved!"
    redirect_to edit_links_path
  end

end
