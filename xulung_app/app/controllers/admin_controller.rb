class AdminController < ApplicationController
	layout "app"
	before_action :admin_required


	def index
		@videos=Video.all.order('created_at DESC')
		@users=User.all.order('created_at DESC')
		@posts=Post.all.approved.order('created_at DESC')
		@posts_draft=Post.all.draft
		@posts_wait_for_approval=Post.not_approved.published

		@pages=Page.all.published
		@pages_draft=Page.all.draft

		@courses_count=Video.all.length
		@users_count=User.all.length
		@posts_count=Post.all.length
		@pages_count=Page.all.length
		fresh_when(:etag => [@videos,@users,@pages,@posts,@pages_draft,@posts_draft,@courses_count,@users_count,@posts_count,@pages_count])
	end

	def be_provider
		session[:return_to] ||= request.referer
		@user = User.find(params[:id])
		@user.provider=!@user.provider
		@user.save
		if @user.provider
			redirect_to session.delete(:return_to), notice: "User is provider now"
		else
			redirect_to session.delete(:return_to), notice: "User is not provider now"
		end

	end
	def approve_post
		@post=Post.friendly.find(params[:id])
		@post.approved=!@post.approved
		if @post.save
			if  @post.approved
		redirect_to :back, notice: "post is appvoed"
			else
		redirect_to :back, notice: "post is not approved"
			end
		end
	end

	def approve_video
		@video = Video.friendly.find(params[:id])
		@video.approved=!@video.approved
		if @video.save
			if @video.approved
			redirect_to :back, notice: "video is appvoed"
			else
			redirect_to :back, notice: "video is not approved"
			end
		end

	end

	def be_admin
		@user = User.find(params[:id])
		@user.admin=!@user.admin
		@user.save
		if @user.admin
			redirect_to :back, notice: "User is admin now"
		else
			redirect_to :back, notice: "User is not admin now"
		end

	end

end
