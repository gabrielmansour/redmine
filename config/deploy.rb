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

namespace :email do
  desc "Uploads the email.yml configuration file in shared path."
  task :setup, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/config" 
    upload "config/email.yml", "#{shared_path}/config/email.yml"
  end
  
  desc "[internal] Updates the symlink for email.yml file to the just deployed release."
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml" 
  end
end
after "deploy:setup", "email:setup"
after "deploy:finalize_update", "email:symlink"


namespace :db do
  desc "Uploads the email.yml configuration file in shared path."
  task :setup, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/config" 
    upload "config/database.yml", "#{shared_path}/config/database.yml"
  end
  
  desc "[internal] Updates the symlink for email.yml file to the just deployed release."
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
after "deploy:setup", "db:setup"
after "deploy:finalize_update", "db:symlink"


after "deploy:finalize_update", "gems:install"
