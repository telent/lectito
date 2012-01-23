class SessionsController < ApplicationController
  def new
  end
  def create
    auth=request.env['omniauth.auth']
    a=Authorization.find_or_create_by_provider_and_uid(auth["provider"],auth["uid"])
    warn [:a,a]
    u=a.user
    warn [:u,u]
    if u then
      session[:user_id]=u.id
      redirect_to "/"
    else
      begin
        i=auth["info"]
        warn [:i,i]
        u=User.create :authorizations=>[a],
        :nickname=>(i["nickname"] || (i["name"].downcase.gsub(/[^a-zA-Z0-9]/,"_"))),
        :avatar=>i["image"],
        :email=>i["email"],
        :fullname=>i["name"]
        a.user=u
        a.save
        session[:user_id]=u.id
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
