class VideosController < ApplicationController

  before_action :authenticate_user!,except: [:index]
  before_action :provider_required, only: [:new, :create, :edit, :update]
  before_action :set_video,only: [:publish,:show,:edit,:update,:upvote]
  before_action :videomembership_check,only: [:show]
  before_action :append_visitor,only: [:show]

  # GET /videos
  # GET /videos.json
  respond_to :html, :json
  def index
    if params[:tag] or params[:query]
      @videos = Video.order('created_at ASC').published.approved.tagged_with(params[:tag]).page(params[:page])
      @tag=params[:tag]
      @tag_counts=@videos.count
    else
      @videos = Video.order('created_at DESC').published.approved.page(params[:page])
    end
    @all_videos = Video.order('created_at DESC').published.approved
    @total_videos=Video.count
    @total_votes=Vote.count
    if @total_videos!=0
      @average_vote=@total_votes/@total_videos
    else
      @average_vote=0
    end

    #meta information
    @tags=@videos.collect(&:tag_list)
    @videos_name=@videos.collect(&:filename)
    @title=t('meta.title')
    @description=@videos_name
    @keywords=@tags

    fresh_when(:etag => [@all_videos,@tags,@description,@title,@keywords,@videos,@tag,@tag_counts,@total_videos,@total_votes,@title])
  end


  def publish
    # @video = Video.find(params[:id])
    @video.published=!@video.published
    @video.save
    if @video.published
      redirect_to :back, notice: "Course was pulished successfully"
    else
      redirect_to :back, notice: "Course was pulished Canceled"
    end

  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    if @video.published
    # @video = Video.find(params[:id])
    @video = Video.friendly.find(params[:id])
    @tag_videos=Video.by_tag(params[:tag])
    @userfavideos=current_user.favorite_videos
    @usernotfavideos=@tag_videos-@userfavideos

    @title=@video.filename
    @description=@video.description
    @keywords=@video.tag_list


    @total_videos=Video.count
    @total_votes=Vote.count
    if @total_videos!=0
      @average_vote=@total_votes/@total_videos
    else
      @average_vote=0
    end
    @video.increment!(:hit)

    render :layout=> 'app'
    fresh_when(:etag => [@tag_videos,@userfavideos,@usernotfavideos,@video,@title,@total_videos,@total_votes])
  else
    redirect_to :back, notice: "Course is not exsited!"
  end

  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
    # @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    @video.user_id = current_user.id
    flash[:notice] = t('videos.created') if @video.save
    respond_with(@video)
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    # @video=Video.find(params[:id])
    @video = Video.friendly.find(params[:id])
    if @video.present?
      @video.destroy
      respond_to do |format|
        format.html { redirect_to videos_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    # redirect_to root_path

  end


  def upvote
    # @video = Video.find(params[:id])
    @video = Video.friendly.find(params[:id])
    @video.votes.create
    redirect_to :back
  end
# def downvote
#     @video = Video.find(params[:id])
#     @video.votes.destroy
#     redirect_to :back, notice: "Thank you for voting!"
# end



private
def append_visitor
  if not @video.visitor_ids.include?(@current_user.id.to_i)
    @video.visitor_ids<<@current_user.id.to_i
    @video.save
  end

end


   def videomembership_check
    # @video = Video.find(params[:video_id] || params[:id])
    @video = Video.friendly.find(params[:id])
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


  def set_video
    # @video = Video.find(params[:id])
    @video = Video.friendly.find(params[:id])
     redirect_to action: [:edit,:show,:update,:destroy], id: @video.friendly_id, status: 301 unless @video.friendly_id == params[:id]
  end


    # Use callbacks to share common setup or constraints between actions.
    def upload_course
      unless current_user.provider?
        flash[:notice]="You are not authorized to access this order"
        redirect_to videos_path
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
    params.require(:video).permit(:filename,:still,:description,:tag_list,:published,:membergroup,:visitor_ids)
    end
  end
