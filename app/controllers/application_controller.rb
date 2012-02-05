require 'active_resource/exceptions'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def check_authorized
    unless ((current_user && current_user.admin?) || yield) then 
      response.status=401
      raise ActiveResource::UnauthorizedAccess.new(response)
    end
  end

  def respond_with(val)
    respond_to do |format|
      format.html 
      format.json { render json: val }
    end
  end
  

end
