class CommentsController < ApplicationController
	def create
		@post = Post.friendly.find(params[:post_id])
		@comment = @post.comments.create!(comment_params)
		# @comment = @commentable.comments.build(params[:comment])
		@comment.author=current_user.username
		@comment.user_id=current_user.id
		@comment.email=current_user.email
		@comment.save
		redirect_to @post
	end

	private


    def comment_params
      params.require(:comment).permit(:author,:user_id,:email,:body)
    end
end
