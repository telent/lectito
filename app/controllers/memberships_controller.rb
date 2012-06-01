class MembershipsController < ApplicationController
  def index
    @collection=Collection.find(params[:collection_id])
    @user=@collection.user
    @memberships=@collection.memberships
    @breadcrumbs=[["friends",following_user_path(@user)]]
  end
  def destroy
    m=Membership.find(params[:id])
    warn [:remove,m]
    m.remove
    redirect_to action: :index
  end
end
