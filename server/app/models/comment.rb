# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :comment, presence: true
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: :Comment, optional: true
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
end
