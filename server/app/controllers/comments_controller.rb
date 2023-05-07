# frozen_string_literal: true

class CommentsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index child_reply]
  before_action :set_comment, only: %i[show update destroy]

  # GET /comments/1
  def index
    @comments = Comment.order('id DESC').where(post_id: params[:id]).where(parent_id: nil).all

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # GET /comments/child/reply
  def child_reply
    @comments = Comment.order('id DESC').where.not(parent_id: nil)

    render json: @comments
  end

  # POST /comments/reply
  def reply
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment
    else
      render json: { reply: @comment.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.permit(:comment, :parent_id, :user_id, :post_id)
  end
end
