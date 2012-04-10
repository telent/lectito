class UsersController < ApplicationController
  def new
    respond_with  @user=User.new
  end
  def index
    respond_with @users=current_user.friends
  end
  def friends
    @users=current_user.friends
    respond_with @users=
      if t=params[:term] then
        @users.find_all {|u| u.name.match Regexp.new(t,Regexp::IGNORECASE) }
      else
        @users
      end
  end

  def edit
  end
  def show
    respond_with @user=User.find(params[:id])
  end
end

