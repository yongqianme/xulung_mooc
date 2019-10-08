class PagesController < ApplicationController
  before_action :admin_required,except: [:index,:show]
  before_action :set_page, only: [:edit,:show,:update,:destroy]
  respond_to :html
  layout "app"
  def index
    # if params[:tag] or params[:title]
    #   @pages = page.order('created_at ASC').tagged_with(params[:tag]).page(params[:page])||page.order('created_at ASC').find_by_title(params[:title]).page(params[:page])
    #   @tag=params[:tag]
    # else
      @pages = Page.order('created_at DESC').published.page params[:page]
    # end

    #meta information
    @title=t('meta.title')
    @description=@pages.collect(&:title)
    @keywords=@pages.collect(&:title)
    respond_with(@pages)

    fresh_when(:etag => [@description,@title,@keywords,@pages,@title])

  end

  def show
    if @page.published
    @title=@page.title
    @description=@page.body
    @keywords=@page.title
    @page.increment!(:hit)
    respond_with(@page)
    fresh_when(:etag => [@title,@description,@keywords])
  else
    redirect_to :back, notice: "Pages is not exsited!"
  end


  end

  def new
    @page = Page.new
    respond_with(@page)
  end


  def edit
    @title=@page.title
  end

  def create
    @page = Page.new(page_params)
    @page.user_id=current_user.id
    @page.author=current_user.username
    if @page.save
      respond_with(@page)
    end
  end

  def update
    @page.update(page_params)
    respond_with(@page)
  end

  def destroy
    @page.destroy
    respond_with(@page)
  end

  private
  def set_page
    # @page = Page.find(params[:id])
    @page = Page.friendly.find(params[:id])
     redirect_to action: [:edit,:show,:update,:destroy], id: @page.friendly_id, status: 301 unless @page.friendly_id == params[:id]
  end

  def page_params
    params.require(:page).permit(:title,:body,:published)
  end

end
