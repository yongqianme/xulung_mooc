class UsersController < ApplicationController
  before_action :authenticate_user!,only: [:edit,:update]
  before_filter :set_user, only: [:apply, :edit, :update]


  # def show
  #   @title=t('meta.title')
  #   @description=""
  #   @keywords=""
  #   # @published_user_posts=Post.where(user_id: @user.id).published.approved
  # end

  def edit
    @user.build_profile if @user.profile.nil?
  end

  private

    def set_user
      # @user = User.find(params[:user_id]||params[:id]||params[:login])
      @user=User.find_by_username(params[:id])
    end

    def user_params
      params.require(:user).permit(profile_attributes: [:avatar,:year,:skill,:payment])
    end

    def authenticate_owner!
      redirect_to root_path unless user_signed_in? && current_user.to_param == params[:id]
    end
end
