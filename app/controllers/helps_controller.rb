class HelpsController < ApplicationController
  def show
    @userprofile = current_user
  end

  def googleslides
    @userprofile = current_user
  end

  def powerpoint
    @userprofile = current_user
  end
end
