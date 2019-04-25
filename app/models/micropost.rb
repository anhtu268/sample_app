class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.validates.micropost.maximum_content}
  validate :picture_size

  scope :order_by_time, ->{order created_at: :desc}
  scope :feed, ->(id){where user_id: id}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    return unless picture.size > Settings.models.micropost.pic_size.megabytes
    errors.add :picture, t("models.micropost.pic_error")
  end
end
