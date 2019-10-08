class PostsController < ApplicationController
  #before_action :admin_required,except: [:index,:show]
  before_action :authenticate_user!,except: [:index]
  before_action :post_owner_required, only: [:edit, :update]
  before_action :set_post, only: [:edit,:show,:update,:destroy]
  before_action :postmembership_check,only: [:show]

  respond_to :html
  def index
    if params[:tag] or params[:title]
      @posts = Post.order('created_at ASC').published.approved.tagged_with(params[:tag]).page(params[:page])||Post.order('created_at ASC').find_by_title(params[:title]).page(params[:page])
      @tag=params[:tag]
    else
      @posts = Post.order('created_at DESC').published.approved.page params[:page]
    end
    #meta information
    @title=t('meta.title')
    @description=@posts.collect(&:title)
    @keywords=@posts.collect(&:title)
    # @tags=Tag.joins(:posts,:taggings).uniq
    @tags=@posts.collect(&:tag_list).uniq
    respond_with(@posts)

    fresh_when(:etag => [@tags,@description,@title,@keywords,@posts,@tag,@title])

  end

  def show

    if @post.published or current_user.admin? or @post.author==current_user
    @title=@post.title
    @description=@post.body
    @keywords=@post.title
    @user=User.find_by username: @post.author
    @post.increment!(:hit)
    respond_with(@post)
    fresh_when(:etag => [@title,@description,@keywords,@user])
  else
    redirect_to :back, notice: "Posts is not exsited!"
  end

  def preview
     @post = Post.friendly.find(params[:id])
    if @post.author=current_user or current_user.admin?
    @title=@post.title
    @description=@post.body
    @keywords=@post.title
    @post.increment!(:hit)
    respond_with(@post)
    fresh_when(:etag => [@title,@description,@keywords])
  else
    redirect_to :back, notice: "Posts is not exsited!"
  end
end

  end

  def publish
    @post = Post.find(params[:post_id] || params[:id])
    if current_user.id = @post.user_id
      @post.published=!@post.published
      if @post.save
        if @post.published
        redirect_to :back, notice: "Post is published"
        else
        redirect_to :back, notice: "Post is moving to draft box"
        end
      end
    end
  end

  def new
    @post = Post.new
    # respond_with(@post)
  end


  def edit
    # @title=@post.title
  end

  def create
    @post = Post.new(post_params)
    @post.user_id=current_user.id
    @post.author=current_user.username
    if @post.save
      redirect_to desktop_index_path
    end
  end

  def update
    @post.update(post_params)
    respond_with(@post)
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  private

   def postmembership_check
    # @post = Post.find(params[:post_id] || params[:id])
    @post = Post.friendly.find(params[:id])
      if @post.author!=current_user and !current_user.try(:admin?)
        case current_user.membership
        when "free"
          if @post.membergroup!="free"
            redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
          end
        when "student"
              if @post.membergroup=="engineer" or @post.membergroup=="enterprise"
                redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
              end
        when "engineer"
          if @post.membergroup=="enterprise"
            redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
          end
        when "enterprise"
        end
      end
  end

  def set_post
    # @post = Post.find(params[:post_id] || params[:id])
    @post = Post.friendly.find(params[:id])
     redirect_to action: [:edit,:show,:update,:destroy], id: @post.friendly_id, status: 301 unless @post.friendly_id == params[:id]
  end


  def post_params
    params.require(:post).permit(:title,:body,:tag_list,:published,:membergroup)
  end
end
