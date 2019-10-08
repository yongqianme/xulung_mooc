class Video < ActiveRecord::Base

  extend FriendlyId
	friendly_id :filename, use: :slugged

	def should_generate_new_friendly_id?
	  new_record? || slug.blank?
	end
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :votes, dependent: :destroy
  mount_uploader :still, StillUploader
  paginates_per 9

  validates :user_id, presence: true

  validates_presence_of :tag_list,:message => "can't be empty"
  validates :filename, length: {
    minimum: 3,
    maximum: 100,
    tokenizer: lambda{|s| s.encode('gb18030').bytes },
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
    },uniqueness: true
    validates_presence_of :still, :message => "no course video selected"
    validates :description,length: {
     minimum: 10,
     maximum: 4000,
     tokenizer: lambda{|s| s.encode('gb18030').bytes },
     too_short: "must have at least %{count} words",
     too_long: "must have at most %{count} words"
   }

   scope :by_tag, lambda { |tag_name| joins(:tags).where("tags.name = ?", tag_name) unless tag_name.blank? }
  	# scope :by_keywords, lambda { |keywords| where("videos.description REGEXP ?", "#{keywords.split(" ").join('|')}") unless keywords.blank? }
  	scope :published, lambda { where(published: true) }
    scope :approved, lambda { where(approved: true) }
  	# scope :by_user, lambda {|userid| where("user_id=?",userid) unless userid==nil}
  	after_initialize :set_default_membergroup, :if => :new_record?
  enum membergroup: [:free, :student, :engineer,:enterprise]

  def set_default_membergroup
    self.membergroup ||= :enterprise
  end

    # has_many :fans, through: :favorites, source: :user

  	# DEFAULT_HIT = 0
  	# default_value_for :hit, DEFAULT_HIT

  	serialize :visitor_ids, Array

  	# after_save :append_visitor
  	# def append_visitor
  	# 	if not self.visitor_ids.include?(self.user_id.to_i)
  	# 		self.visitor_ids << self.user_id.to_i
  	# 	end
  	# end

  	def visitors
  		User.where(:id => self.visitor_ids)
  	end
  	# before_save :save_default_user_id
  	# def save_default_user_id

  	# 	if current_user.present?
  	# 	if self.user_id.nil?
  	# 			self.user_id = current_user.id
  	# 		end
  	# 	end
  	# end
    #
  #   def to_param
  #   "#{id}-"+PinYin.permlink(filename).parameterize
  # end

  	def self.user(name)
  		find_by_name!(name).videos
  	end

  	def set_success(format, opts)
  		self.success = true
  	end

  	def self.tagged_with(name)
  		Tag.find_by_name!(name).videos
  	end

  	def self.tag_counts
  		Tag.joins(:videos,:taggings).uniq.select("tags.*, count(taggings.tag_id) as count").group("taggings.tag_id,taggings.video_id")
  	end

  	def tag_list
  		tags.map(&:name).join(", ")
  		# tags.map(|tag| tag.name).join(", ")
  	end

  	def tag_list=(names)
  		self.tags = names.split(",").map do |n|
  			Tag.where(name: n.downcase.strip).first_or_create!
  		end
  	end

# before_save :store_metadata

#   private
#   def store_metadata

#       file_path =self.still_url
#         file = Mediainfo.new file_path
#         if file.video?
#             video_meta(file, file_path)
#         end
#   end

#   def video_meta(file, file_path)
#     self.filesize = file.size
#     self.bit_rate = file.video.bit_rate
#     self.duration = file.video.duration
#     self.checksum = ::Digest::MD5.file(file_path).hexdigest
#     self.width = file.video.width
#     self.height = file.video.height
#   end



	# def self.by_votes
	# 	select('videos.*, coalesce(value, 0) as votes').
	# 	joins('left join votes on video_id=videos.id').
	# 	order('votes desc')
	# end

end
