class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build 
    @feed_items = current_user.feed.recent.page(params[:page])
      .per Settings.microposts.paging.num_per_page
  end

  def help; end

  def about; end
end
