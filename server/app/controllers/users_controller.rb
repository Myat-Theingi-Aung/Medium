# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create profile forgot_password reset_password]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render json: { error: @user.errors }, status: :unprocessable_entity
    end
  end

  # GET /users/1
  def profile
    @users = User.all
    @user = User.find(params[:id])
    @categories = Category.all
    @posts = Post.where(user_id: params[:id]).all
    @count = @posts.count

    render json: { users: @users, user: @user, posts: @posts, count: @count, categories: @categories }
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def image_delete
    user = User.find(params[:id])
    user.image.delete
    user.image_data = nil
    user.save

    render json: user
  end

  def password
    @user = User.find(params[:id])
    if @user.authenticate(params[:old_password])
      @user.update(pass_params)
      if @user.valid?(:update_password)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'password is invalid' }, status: :unauthorized
    end
  end

  def forgot_password
    @user = User.find_by(email: params[:email])
    if @user
      UserMailer.send_reset_password_mail(@user.email).deliver
      render json: @user
    else
      render json: 'Email is invalid', status: :unprocessable_entity
    end
  end

  def reset_password
    @user = User.find(params[:id])
    @user.update(pass_params)
    if @user.valid?(:update_password)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @posts = Post.where(user_id: params[:id]).all
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :bio, :image, :role)
  end

  def pass_params
    params.permit(:password, :password_confirmation)
  end
end
