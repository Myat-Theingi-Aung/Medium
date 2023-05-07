# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :post, optional: true
end
