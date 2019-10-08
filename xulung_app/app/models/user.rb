class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :invitable, :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,:validatable,:authentication_keys => [:login]
  enum membership: [:free, :student, :engineer,:enterprise]
  # attr_accessor :login,:membership
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true,case_sensitive: false
  # validates_acceptance_of :terms_of_service, :allow_nil => false, :accept => true
  validates :terms_of_service, acceptance: { accept: true }
  has_many :videos,dependent: :destroy
  has_many :favorites
  has_many :favorite_videos, through: :favorites, source: :favorited, source_type: 'Video'
  # has_many :invites
  has_many :photos
  has_many :orders
  has_one :consultant, dependent: :destroy
  accepts_nested_attributes_for :consultant
  after_create :send_welcome_mail
    def send_welcome_mail
      Welcome.welcome_greetings(self).deliver
    end

  def to_param
    # "#{id}#{login}"
    login
  end


  def add_to_courselist(video)
    self.courselist.videos << video
  end

  def self.courselist
    Courselist.where("user_id=?",self.id)
  end
  def create_courselist
    self.courselist=Courselist.new
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
   else
     where(conditions).first
   end
 end
 def login=(login)
  @login = login
end

def login
  @login || self.username || self.email
end

def set_provider
  self.provider=false
end

private
def set_admin
  self.admin = true  if User.count == 0
end
def self.create_with_password(attr={})
   generated_password = Devise.friendly_token.first(8)
   generated_username = Randomstring.generate(7)
   self.create(attr.merge(username: generated_username,password: generated_password, password_confirmation: generated_password))
   # print(generated_username)
   # RegistrationMailer.welcome(user, generated_password).deliver
end


end
