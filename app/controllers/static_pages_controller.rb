class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.order_by_time.page(params[:page])
      .per Settings.controllers.static_pages.pag
  end

  def help; end

  def about; end

  def contact; end
end
