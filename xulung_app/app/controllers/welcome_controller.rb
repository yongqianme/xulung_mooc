class WelcomeController < ApplicationController
	layout 'home'
	def tos
	end
	def policy
		@policy=""
	end

	def home
		# @howtovideo=Video.find(79)
		@videos = Video.order('created_at DESC').published
		# @recommended_videos=User.find(1).favorite_videos
		@tags=Tag.all.collect(&:name)
		@videos_name=@videos.collect(&:filename)

		@title=t('meta.title')
		@description=t('meta.description')
		@keywords=t('meta.keywords')
		fresh_when(:etag => [@videos,@tags,@videos_name,@title,@description,@keywords])
	end

	def index

		@title=t('meta.title')
		@description=t('meta.description')
		@keywords=t('meta.keywords')
		@videos = Video.order('created_at DESC').published
		fresh_when(:etag => [@videos])
	end

	# def set
	# 	I18n.locale = params[:locale]
	# 	redirect_to :back
	# end

end
