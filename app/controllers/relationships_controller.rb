class RelationshipsController < ApplicationController
  def index
    @user=User.find(params[:user_id])
    @following=@user.following_rel
    @followers=@user.follower_rel
  end
  def destroy
    m=Relationship.find(params[:id])
    m.unfollow
    redirect_to action: :index
  end
  def create
    Relationship.follow(:follower=>current_user, :followed=>User.find(params[:id]))
    redirect_to action: :index
  end
  def breadcrumb
    @breadcrumbs=[["friends",user_relationships_path(current_user)]]
  end
end
