require 'bundler/capistrano'
load 'deploy/assets'

set :application, "lectito"

set :repository,  "git@github.com:telent/lectito.git"
set :scm, :git

role :web, "btyemark.telent.net"
role :app, "btyemark.telent.net"
role :db,   "btyemark.telent.net", :primary => true 

set :user, "lectito"
set :ssh_options, {keys: "lectito_key", forward_agent: true }
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}" 

set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}


set :stage, :production

set :shared_children, shared_children << 'tmp/sockets'

namespace :deploy do
  desc "Start the application"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec puma -b 'tcp://127.0.0.1:1974/' -S #{shared_path}/sockets/puma.state --control 'unix://#{shared_path}/sockets/pumactl.sock' >> #{shared_path}/log/puma-#{stage}.log 2>&1 &", :pty => false
  end

  desc "Stop the application"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stop"
  end

  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state restart"
  end

  desc "Status of the application"
  task :status, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stats"
  end
end
