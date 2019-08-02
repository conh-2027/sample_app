class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
    length: { maximum: Settings.microposts.content.max_length }
  mount_uploader :picture, PictureUploader
  validate :picture_size

  belongs_to :user
  scope :recent, -> {order created_at: :desc }
  scope :by_user_ids, -> user_ids { where user_id: user_ids}
  delegate :name, to: :user, prefix: true

  private

  def picture_size
    return unless picture.size > Settings.microposts.max_size.megabytes
    errors.add(:picture, t(".uploader_error"))
  end
end
