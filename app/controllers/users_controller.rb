class UsersController < ApplicationController
  def new
    respond_with  @user=User.new
  end
  def index
    respond_with @users=current_user.friends
  end
  def friends
    u=current_user.friends
    from=params[:from].to_i 
    to=params[:to].to_i 
    u=
      if t=params[:term] then
        u.find_all {|u| u.name.match Regexp.new(t,Regexp::IGNORECASE) }
      else
        u
      end
    # upper bound is exclusive not inclusive
    to=if to.zero? then to.count else to-1 end
    respond_with @users=u[from..to]
  end

  def followers
    @user=UserDecorator.find(params[:id])
    @breadcrumbs=[["friends",following_user_path(@user)]]
    @followers=@user.followers
  end

  def following
    @user=UserDecorator.find(params[:id])
    @breadcrumbs=[["friends",following_user_path(@user)]]
    @following=@user.following
  end

  def edit
  end

  def show
    respond_with @user=UserDecorator.find(params[:id])
  end
  
  def block
    current_user.block(@user=UserDecorator.find(params[:id]))
    redirect_to action: :show
  end

  def unblock
    current_user.unblock(@user=UserDecorator.find(params[:id]))
    redirect_to action: :show
  end

  def follow
    current_user.follow(@user=UserDecorator.find(params[:id]))
    redirect_to action: :show
  end

  def unfollow
    current_user.unfollow(@user=UserDecorator.find(params[:id]))
    redirect_to action: :show
  end

  def breadcrumb
    @breadcrumbs=[["profile",current_user]]
  end
end

