class UsersController < ApplicationController
  def index
    @users = User.all
    @friends = current_user.friends
    @pending_requests = current_user.pending_requests
    @friend_requests = current_user.received_requests
  end

  def show
    @user = User.find(params[:id])
  end

  def update_image
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_back(fallback_location: users_path(current_user))
      return
    end
    image = params[:user][:image] unless params[:user].nil?
    if image
      @user.image = image
      if @user.save
        flash[:success] = 'Image Uploaded' 
      else
        flash[:danger] = 'Image Uploaded Failed'
      end
    end
    redirect_back(fallback_location: root_path)
  end
end
