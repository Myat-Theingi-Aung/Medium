# frozen_string_literal: true

class User < ApplicationRecord
  include ImageUploader::Attachment(:image)
  require 'securerandom'
  enum role: %i[admin user], _default: 'user'
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :password_confirmation, presence: true, on: :create
  with_options on: :update_password do
    validates :password, presence: true
    validates :password_confirmation, presence: true
  end
  validates :bio, presence: true
end
