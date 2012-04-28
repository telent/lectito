class SessionsController < ApplicationController
  layout "splash"
  def new
  end
  def create
    auth=request.env['omniauth.auth']
    a=Authorization.find_or_create_by_provider_and_uid(auth["provider"],auth["uid"])
    u=a.user
    c=auth["credentials"]
    if c && t=c["token"] then
      a.token=t
    end
    if c && t=c["secret"] then
      a.secret=t
    end
    if u then
      session[:user_id]=u.id
      a.save
      redirect_to stories_path
    elsif uid=session[:user_id] then
      # adding new authorization to existing user
      u=User.find(uid)
      a.user=u
      a.save
      redirect_to stories_path
    else
      begin
        i=auth["info"]
        u=User.create :authorizations=>[a],
        :nickname=>(i["nickname"] || (i["name"].downcase.gsub(/[^a-zA-Z0-9]/,"_"))),
        :avatar=>i["image"],
        :email=>i["email"],
        :fullname=>i["name"]
        a.user=u
        a.save
        session[:user_id]=u.id
        u.welcome!
        redirect_to stories_path
      rescue Exception => e
        warn [:except,e]
      end
    end
  end
  def destroy
    session.delete(:user_id)
  end
end
