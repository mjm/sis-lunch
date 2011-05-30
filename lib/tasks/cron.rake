require File.expand_path('../../../config/environment', __FILE__)

task :cron do
  Place.destroy_all
  Vote.destroy_all
end