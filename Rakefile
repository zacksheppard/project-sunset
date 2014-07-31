# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :gen_seed_data => :environment do
    City.print_cities_for_seed_data
end

namespace :db do
  task :add_data => :environment do
      City.generate_cities
  end
end
