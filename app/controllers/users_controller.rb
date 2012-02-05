class UsersController < ApplicationController
  def new
    respond_with  @user=User.new
  end
  def index
    respond_with @users=current_user.friends
  end
  def edit
  end
  def show
    respond_with @user=User.find(params[:id])
  end
end

