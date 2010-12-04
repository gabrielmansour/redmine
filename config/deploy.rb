role :web, "dev.yousayyeah.com"
role :app, "dev.yousayyeah.com"
role :db,  "dev.yousayyeah.com", :primary => true
role :db,  "dev.yousayyeah.com"

default_run_options[:pty] = true
set :repository,  "git@github.com:gabrielmansour/redmine.git"
set :application, "redmine"
set :scm, "git"

set :deploy_to,    "/Library/WebServer/#{application}"
set :branch, "sayyeah"

set :user, "admin"
set :deploy_via,   :export

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end