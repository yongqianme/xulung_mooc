class Comment < ActiveRecord::Base
	# validates_presence_of :body,:author,:email,:user_id
	validates_presence_of :body
	belongs_to :post
end
