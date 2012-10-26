class AuthorizationsController < ApplicationController
  def index
    @user=UserDecorator.find(params[:user_id])
    respond_with @authorizations=@user.authorizations
  end

  def destroy
    @user=User.find(params[:user_id])
    @user.authorizations.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to user_authorizations_path(@user), notice: 'Account was successfully unlinked.' }
      format.json { head :no_content }
    end
  end

end
