# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split.last if header
    if header.nil?
      render json: { error: 'login first' }, status: :unauthorized
    else
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    end
  end

  def current_user
    @current_user ||= User.find(decoded[:user_id]) if decoded[:user_id]
  end
end
