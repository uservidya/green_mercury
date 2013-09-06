require "rvm/capistrano"
require 'bundler/capistrano'
require "dotenv/capistrano"

set :application, "green_mercury"
set :repository,  "https://github.com/code-scouts/green_mercury.git"
set :scm, :git

role :web, "ec2-54-200-1-25.us-west-2.compute.amazonaws.com" # Your HTTP server, Apache/etc
role :app, "ec2-54-200-1-25.us-west-2.compute.amazonaws.com" # This may be the same as your `Web` server
role :db,  "ec2-54-200-1-25.us-west-2.compute.amazonaws.com", :primary => true # This is where Rails migrations will run

set :user, 'green_mercury'
set :use_sudo, false

set :rvm_ruby_string, '1.9.3@green_mercury'
set :rvm_type, :system

namespace :deploy do
  desc "start unicorn!"
  task :start do
    run "cd #{current_path} && RAILS_ENV=production bundle exec unicorn -p 3000 -c ./config/unicorn.rb -D"
  end

  desc "ask unicorn to restart gracefully"
  task :restart, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
  end

  desc "Stop unicorn. Use with caution!"
  task :stop do
    run "kill `cat #{shared_path}/pids/unicorn.pid`"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
