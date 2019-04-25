class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    redirect_to root_url unless (@user = User.find_by id: params[:followed_id])
    current_user.follow @user
    respond_ajax
  end

  def destroy
    redirect_to root_url unless (@user = Relationship.find_by(id: params[:id]).followed)
    current_user.unfollow @user
    respond_ajax
  end

  private
  def respond_ajax
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
