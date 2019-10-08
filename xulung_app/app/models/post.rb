class Post < ActiveRecord::Base


	validates_presence_of :body, :title
	has_many :comments
	has_many :taggings
  has_many :tags, through: :taggings

  scope :by_tag, lambda { |tag_name| joins(:tags).where("tags.name = ?", tag_name) unless tag_name.blank? }
	scope :published, lambda { where(published: true) }
	scope :draft, lambda { where(published: false) }
	scope :approved, lambda { where(approved: true) }
	scope :not_approved, lambda { where(approved: false) }

  after_initialize :set_default_membergroup, :if => :new_record?
  enum membergroup: [:free, :student, :engineer,:enterprise]

	extend FriendlyId
	friendly_id :title, use: :slugged

	def should_generate_new_friendly_id?
	  new_record? || slug.blank?
	end

  def set_default_membergroup
    self.membergroup ||= :free
  end

	# def to_param
	# 	"#{id}-"+PinYin.permlink(title).parameterize
	# end

	def self.user(name)
  		find_by_name!(name).posts
  	end
	def self.tagged_with(name)
  		Tag.find_by_name!(name).posts.published
  	end

  	def self.tag_counts
      Tag.joins(:posts,:taggings).uniq.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
    end

  	def tag_list
  		self.tags.map(&:name).join(", ")
  	end

  	def tag_list=(names)
  		self.tags = names.split(",").map do |n|
  			Tag.where(name: n.downcase.strip).first_or_create!
  		end
  	end
end
