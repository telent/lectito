CONF=YAML::load(ERB.new(IO.read(File.join(Rails.root,'config','omniauth.yml'))).result)[Rails.env]

#require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  t=CONF["twitter"]
  warn t
  provider :twitter, t["consumer_key"],t["consumer_secret"]
  f=CONF["facebook"]
  provider :facebook,f["app_id"], f["app_secret"]
#  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "google", :identifier => "https://www.google.com/accounts/o8/id" }
#  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "yahoo", :identifier => "https://me.yahoo.com"}

end

