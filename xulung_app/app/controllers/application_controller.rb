class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  after_filter :store_location
  respond_to :html, :json

  before_action :set_locale
  valid_locales=['en','zh-CN']

  private
  def set_locale
    # I18n.locale =  cookies[:locale] || setup_locale
    I18n.locale = params[:locale] || cookies[:locale] || setup_locale
  end

  def setup_locale
    if user_signed_in?
      current_user.update_attribute(:locale, guess_browser_language) if current_user.locale.blank?
      return cookies[:locale] = current_user.locale
    else
      return cookies[:locale] = guess_browser_language
    end
  end

  def guess_browser_language
    request.accept_language.split(/,/).each{|language|
      if language =~ /zh-CN/i
        return 'zh-CN'
      else
        return I18n.default_locale
      end
    } unless request.accept_language.blank?
    return I18n.default_locale
  end

  def user_cannot_see
    if !user_signed_in? and !current_user.try(:admin?)
      redirect_to service_membership_path
    end
  end


  def admin_required
    if !current_user.try(:admin?)
      redirect_to root_url, alert: "Contact us for access to this page."
    end
  end

  # def membership_check
  #   @video = Video.find(params[:video_id] || params[:id])
  #   @post = Post.find(params[:post_id] || params[:id])
  #   if @post.membergroup!=0 or @video.membergroup!=0
  #   if !current_user.try(:admin?) or current_user!=@video.author or current_user!=@post.author
  #     if current_user.membership!=@video.membergroup or current_user.membership!=@post.membergroup
  #       redirect_to service_membership_path, notice: "您当前的会员级别无法查看此课程，请升级您的会员."
  #     end
  #   end
  #   end
  # end


  def post_owner_required
    @post = Post.friendly.find(params[:id])
    if current_user.id != @post.user_id and !current_user.try(:admin?)
      redirect_to root_url, alert: "Contact us for access to this post."
    end
  end

  def provider_required
    if !current_user.try(:provider?)
      redirect_to root_url, alert: "Contact us for access to this page."
    end
  end

  def user_is_teacher?
    return true if current_user.provider||current_user.admin
  end


  def is_published
    unless @video.published?
      redirect_to videos_path
    end
  end

  def layout_by_resource
      if browser.device.mobile? and !devise_controller?
        'mobile'
      elsif devise_controller?
        'app'
      else
        'application'
      end
  end



# prepend_before_filter :disable_devise_trackable


#   def disable_devise_trackable
#     request.env["devise.skip_trackable"] = true
#   end




def store_location
  # store last url - this is needed for post-login redirect to whatever the user last visited.
  return unless request.get?
  if (request.path != "/users/sign_in" &&
      request.path != "/users/sign_up" &&
      request.path != "/users/password/new" &&
      request.path != "/users/password/edit" &&
      request.path != "/users/confirmation" &&
      request.path != "/users/sign_out" &&
      !request.xhr?) # don't store ajax calls
    session[:previous_url] = request.fullpath
  end
end


  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_up_path_for(resource_or_scope)
    session[:previous_url] || root_path
    # session[:previous_url]
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:previous_url] || desktop_index_path
  #  session[:previous_url]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation,:provider,:remember_me,:terms_of_service) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me,:provider) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password,:provider,:terms_of_service) }
  end


end
