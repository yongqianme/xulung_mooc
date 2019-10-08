class ConsultantsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_consultant, only: [:edit,:show,:update,:destroy]
	before_action :enterprise_only, only:[:index,:show]
	before_action :owner, only: [:show,:edit,:update,:destroy]
	respond_to :html
	def index
    @consultants = Consultant.order('created_at DESC').page params[:page]
    @title=@consultants.collect(&:position)
    @description=@consultants.collect(&:experience)
    @keywords=@consultants.collect(&:position)
    respond_with(@consultants)
    fresh_when(:etag => [@description,@title,@keywords,@consultants])
  end

  def show
    @title=@consultant.position
    @description=@consultant.experience
    @keywords=@consultant.position
    respond_with(@consultant)
    fresh_when(:etag => [@title,@description,@keywords])
  end

def new
	if current_user.consultant ==nil
    @consultant = Consultant.new
	else
		redirect_to desktop_index_path,notice: "您已经是技术顾问"
  end

  end


  def edit
		# @consultant = current_user.consultant
    # @title=@consultant.title
  end

  def create
    @consultant = Consultant.new(consultant_params)
    @consultant.user_id=current_user.id
    @consultant.email=current_user.email
    if @consultant.save
      redirect_to @consultant
    end
  end

  def update
    @consultant.update(consultant_params)
    # respond_with(@consultant)
		redirect_to desktop_index_path
  end

  def destroy
    @consultant.destroy
    respond_with(@consultant)
  end

	private

	def set_consultant
		if current_user.consultant!=nil
			@consultant=current_user.consultant
		else
    @consultant = Consultant.find(params[:id])
	end
  end

		def consultant_params
			params.require(:consultant).permit(:realname,:user_id,:tel,:email,:alipay,:dashang,:company,:workyear,:position,:hourrate,:experience,:avatar,:dashang)
		end

				def owner
		     if !current_user.try(:admin?) and @consultant.user!=current_user
		        redirect_to service_membership_path, notice: "您无权查看"
		     end
		   end

		def enterprise_only
     if !current_user.try(:admin?) and current_user.membership!="enterprise"
        redirect_to service_membership_path, notice: "技术顾问信息只对企业客户开放，请升级您的会员"
     end
   end

end
