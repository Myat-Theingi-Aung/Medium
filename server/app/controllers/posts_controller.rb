# frozen_string_literal: true

class PostsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show category_list home]
  before_action :set_post, only: %i[show update destroy]

  def home
    @posts = Post.order('id DESC').all
    @categories = Category.all
    @users = User.all

    render json: { posts: @posts, users: @users, categories: @categories }
  end

  # GET /posts
  def index
    @categories = Category.all
    @users = User.all
    @last_posts = Post.order('id DESC').first(4)
    if params[:search].blank?
      @posts = Post.order('id DESC').all
    else
      search = params[:search]
      @posts = Post.where(['title LIKE ?', "%#{search}%"]).order('id DESC').all
    end

    render json: { posts: @posts, categories: @categories, users: @users, latest: @last_posts }
  end

  # GET category/name
  def category_list
    @categories = Category.all
    @users = User.all
    @category = Category.where(name: params[:name]).first
    @posts = Post.where(category_id: @category.id).all

    render json: { posts: @posts, categories: @categories, category: @category, users: @users }
  end

  # GET /posts/1
  def show
    @users = User.all
    @last_posts = Post.order('id DESC').first(4)
    @count = Comment.where(post_id: @post.id).where(parent_id: nil).count

    render json: { post: @post, users: @users, latest: @last_posts, count: @count }
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  # POST /post/import
  def import
    input = params[:file]
    if input.content_type == 'text/csv'
      file = File.open(input)
      CSV.foreach(file.path, headers: true) do |row|
        post_hash = {}
        post_hash[:title] = row['Title']
        post_hash[:description] = row['Description']
        uploader = ImageUploader.new(:store)
        file = File.new(Rails.root.join("app/assets/images/#{row['Image']}"))
        uploaded_file = uploader.upload(file)
        post_hash[:image_data] = uploaded_file.to_json
        user = User.where(name: row['Username']).first
        post_hash[:user_id] = user.id
        category = Category.where(name: row['Category name']).first
        post_hash[:category_id] = category.id
        Post.create! post_hash
      end
    else
      render json: { error: 'file type must be: text/csv' }, status: :unprocessable_entity
    end
  end

  # POST /post/export
  def export
    posts = Post.all
    headers = ['Title', 'Image', 'Description', 'Username', 'Category name']
    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
      posts.each do |post|
        csv << [post.title, JSON.parse(post.image_data)['metadata']['filename'], post.description, post.user.name,
                post.category.name]
      end
    end
    send_data(
      csv_data
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.permit(:title, :description, :image, :user_id, :category_id)
  end
end
