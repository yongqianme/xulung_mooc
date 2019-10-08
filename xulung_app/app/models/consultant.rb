class Consultant < ActiveRecord::Base
  validates_presence_of :realname,:tel,:alipay,:company,:position,:workyear,:hourrate,:experience
  belongs_to :user
  mount_uploader :avatar, AvatarUploader
  mount_uploader :dashang, DashangUploader
  #
  # validates :tel, presence: true, uniqueness: true
  # validates :alipay, presence: true, uniqueness: true
end
