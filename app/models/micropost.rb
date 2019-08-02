class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
    length: { maximum: Settings.microposts.content.max_length }
  mount_uploader :picture, PictureUploader
  validate :picture_size

  delegate :name, to: :user, prefix: true

  scope :recent, -> {order(created_at: :desc)}

  private

  def picture_size
    return unless picture.size > Settings.microposts.max_size.megabytes
    errors.add(:picture, t(".uploader_error"))
  end
end
