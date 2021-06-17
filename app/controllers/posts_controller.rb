class PostsController < ApplicationController
  def index
    @our_posts = current_user.friend_and_own_posts
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.post.build(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def destroy; end
  
  private

  def post_params
    params.require(:post).permit(:content, :imageURL)
  end
end
