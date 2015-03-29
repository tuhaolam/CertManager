require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :password
  validates :password, :first_name, :last_name, presence: true
  validates :email, email: true, uniqueness: true
  validates :password, length: { within: 6..128 }
  before_save :update_password

  def password_matches?(pwd)
    password_hash == User.hash_password(pwd, password_salt)
  end
  def create_confirm_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
    self.confirmation_sent_at = Time.now
  end
  def randomize_password
    self.password = SecureRandom.urlsafe_base64(32)
  end
  def to_s
    "#{first_name} #{last_name}"
  end
  def self.authenticate(username, password)
    user = find_by_email(username)
    return user.try(:password_matches?, password) and user.try(:can_login?)
  end

  private
  def update_password
    if self.password
      self.password_salt = SecureRandom.random_bytes(32)
      self.password_hash = User.hash_password(password, password_salt)
    end
  end
  def self.hash_password(pwd, salt)
    Digest::SHA256.digest("#{pwd}#{salt}")
  end
end