class MembershipsController < ApplicationController
  def index
    @collection=Collection.find(params[:collection_id])
    @memberships=@collection.memberships
  end
  def destroy
    m=Membership.find(params[:id])
    warn [:remove,m]
    m.remove
    redirect_to action: :index
  end
end
