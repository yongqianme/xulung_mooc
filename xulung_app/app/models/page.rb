class Page < ActiveRecord::Base

	validates_presence_of :body, :title
	# has_many :comments
	# has_many :taggings
 #  has_many :tags, through: :taggings


		mount_uploader :image, PostimgUploader

  # scope :by_tag, lambda { |tag_name| joins(:tags).where("tags.name = ?", tag_name) unless tag_name.blank? }
 	scope :published, lambda { where(published: true) }
	scope :draft, lambda { where(published: false) }

	extend FriendlyId
	friendly_id :title, use: :slugged

	def should_generate_new_friendly_id?
	  new_record? || slug.blank?
	end

	# def to_param
	# 	"#{id}-"+PinYin.permlink(title).parameterize
	# end

	def self.user(name)
  		find_by_name!(name).pages
  	end
	# def self.tagged_with(name)
 #  		Tag.find_by_name!(name).pages
 #  	end

 #  	def self.tag_counts
 #      Tag.joins(:pages,:taggings).uniq.select("tags.*, count(taggings.tag_id) as count").
 #      joins(:taggings).group("taggings.tag_id")
 #    end

 #  	def tag_list
 #  		self.tags.map(&:name).join(", ")
 #  	end

 #  	def tag_list=(names)
 #  		self.tags = names.split(",").map do |n|
 #  			Tag.where(name: n.downcase.strip).first_or_create!
 #  		end
 #  	end

end
