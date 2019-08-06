class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,  length: { minimum: Settings.user.name.min_length ,
   maximum: Settings.user.name.max_length }
  VALID_EMAIL_REGEX =  Settings.user.email.regex
  VALID_PASSWORD_REGEX = Settings.user.password.regex
  validates :email, presence: true, length: { maximum: Settings.user.email.max_length },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
  validates :password, length: { minimum: Settings.user.password.min_length,
    maximum: Settings.user.password.max_length },
    format: { with: VALID_PASSWORD_REGEX}, allow_nil: true
   
  USER_PARAMS = %i(name email password password_confirmation)
   
  has_secure_password
  
  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? attribute,token
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end
  
  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
