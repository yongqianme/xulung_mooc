class FavoritesController < ApplicationController
  before_action :authenticate_user!
	before_action :set_video
  before_action :videomembership_check

  def create
  	@favorite=Favorite.create(favorited: @video, user: current_user)
    if @favorite.save
      redirect_to :back, notice: t('videos.added_list')
    else
      redirect_to :back, alert: 'Something went wrong...*sad panda*'
    end
  end


  def destroy
    Favorite.where(favorited_id: @video.id, user_id: current_user.id).first.destroy
    redirect_to :back, notice: t('videos.removed_fromlist')
  end

  private

  def set_video
    # @video = Video.find(params[:video_id] || params[:id])
    @video = Video.friendly.find(params[:video_id] || params[:id])
  end

  def videomembership_check
  #  @video = Video.find(params[:video_id] || params[:id])
   @video = Video.friendly.find(params[:video_id]||params[:id])
   if !current_user.try(:admin?) and @video.user!=current_user
     case current_user.membership
       when "free"
         if @video.membergroup!="free"
           redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
         end
       when "student"
             if @video.membergroup=="engineer" or @video.membergroup=="enterprise"
               redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
             end
       when "engineer"
         if @video.membergroup=="enterprise"
           redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
         end
     end
   end
 end



end
