# frozen_string_literal: true

class Post < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  belongs_to :category, optional: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :image, presence: true
  validates :description, presence: true, length: { minimum: 20 }
end
