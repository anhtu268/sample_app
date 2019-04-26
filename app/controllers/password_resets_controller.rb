class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      return unless @user.create_reset_digest
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controllers.password_resets.create_success"
      redirect_to root_url
    else
      flash.now[:danger] = t "controllers.password_resets.create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("controllers.password_resets.update_fail")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t "controllers.password_resets.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    return if @user = User.find_by(email: params[:email])
    flash[:danger] = t "controllers.password_resets.not_found"
    redirect_to new_password_reset_url
  end

  def valid_user
    redirect_to root_url unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controllers.password_resets.pass_expired"
    redirect_to new_password_reset_url
  end
end
