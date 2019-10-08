class DesktopController < ApplicationController

	layout "desktop"
	layout "learning",only: [:startlearning]
	# before_action :admin_required
	before_action :authenticate_user!
	before_action :user_cannot_see,only: [:show,:mycourse,:report]


	def index
		if params[:tag]
			@videos = Video.order('created_at ASC').published.by_tag(params[:tag]).page(params[:page])
			@tag=params[:tag]
			@tag_counts=@videos.count
		else
			@videos = Video.order('created_at ASC').published.page params[:page]
		end
		@user_favideos=current_user.favorite_videos
		@consultant=current_user.consultant
		@total_videos=Video.count
		@total_votes=Vote.count
		if @total_videos!=0
			@average_vote=@total_votes/@total_videos
		else
			@average_vote=0
		end
		@posts=Post.all.published
		@drafts=Post.all.draft
		@useruploadedvideos=Video.where("user_id=?",current_user.id)

		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags

		@published_user_posts=Post.where(user_id: current_user.id).published.approved
		@user_drafts=Post.where(user_id: current_user.id).draft
		@approving_user_posts=Post.where(user_id: current_user.id).not_approved

		fresh_when(:etag => [@published_user_posts,@user_drafts,@approving_user_posts,@videos,@tag,@tag_counts,@total_votes,@total_videos,@title,@useruploadedvideos])
	end
	def tech
		@videos = Video.order('created_at ASC').published

		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags

		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end

	def show
		@video = Video.find(params[:id])
		@video.increment!(:hit)

		@title=@video.filename
		@description=@video.description
		@keywords=@video.tag_list
		fresh_when(:etag =>[@video,@title,@description,@keywords])
	end
	def mycourse
		@videos=current_user.favorite_videos.page params[:page]
		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags
		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end

	def report
		@user_favideos=current_user.favorite_videos
		@tags=Tag.all.collect(&:name)
		@videos_name=@user_favideos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags
		fresh_when(:etag => [@user_favideos,@tags,@videos_name,@title,@description,@keywords])
	end
	def course
		@videos=Video.order('created_at ASC').published
		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags
		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end
	def listcourse
		@videos=Video.order('created_at ASC').published
		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags
		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end
	def listtagcourse
		@videos=Video.order('created_at ASC').published.page(params[:page])
		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)
		@title=t('meta.title')
		@description=@videos_name
		@keywords=@tags
		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end
	def sharetech
		@posts=Post.where(user_id: current_user.id).published
		@drafts=Post.where(user_id: current_user.id).draft
		fresh_when(:etag=> [@posts])
	end


	def startlearning

		if params[:tag]
      @videos = Video.order('created_at DESC').published.approved.tagged_with(params[:tag])
			@video = Video.order('created_at DESC').published.approved.tagged_with(params[:tag]).first
      @tag=params[:tag].upcase
      @tag_counts=@videos.count
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

		fresh_when(:etag=> [@videos,@tag,@tag_counts,@video])
	end

	def publish
    @post = Post.find(params[:id])
    if current_user.id != @post.user_id and !current_user.try(:admin?)
      @post.published=!@post.published
      if @post.save
        if @post.published
        redirect_to desktop_index_path, notice: "Post is published"
        else
        redirect_to desktop_index_path, notice: "Post is moving to draft box"
        end
      end
    end
  end


end
