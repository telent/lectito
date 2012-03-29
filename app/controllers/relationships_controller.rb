class RelationshipsController < ApplicationController
  def index
    @user=User.find(params[:user_id])
    @following=@user.following_rel
    @followers=@user.follower_rel
  end
  def destroy
    m=Relationship.find(params[:id])
    warn [:remove,m]
    m.unfollow
    redirect_to action: :index
  end
end
