class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,  length: { minimum: Settings.user.name.min_length ,
   maximum: Settings.user.name.max_length }
  VALID_EMAIL_REGEX =  Settings.user.email.regex
  VALID_PASSWORD_REGEX = Settings.user.password.regex
  validates :email, presence: true, length: { maximum: Settings.user.email.max_length },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
  validates :password, length: { minimum: Settings.user.password.min_length,
   maximum: Settings.user.password.max_length },
   format: { with: VALID_PASSWORD_REGEX}

  USER_PARAMS = %i(name email password password_confirmation)
  
  has_secure_password
  
  private

  def downcase_email
    email.downcase!
  end
end
