# frozen_string_literal: true

class SigninController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token, user: @user }, status: :ok
    else
      render json: { errors: { error: 'Email or password is invalid' } }, status: :unauthorized
    end
  end
end
