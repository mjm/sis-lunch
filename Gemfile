source 'http://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sass'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

gem 'rdiscount'

gem 'thin'
gem 'bcrypt-ruby'

gem 'rabl'
gem 'json'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.4'
  gem 'factory_girl_rails'

  gem 'sqlite3'
  gem 'simplecov'

  # if RUBY_PLATFORM.downcase.include?("darwin")
  #   gem 'rb-fsevent', '~> 0.9'
  #   gem 'growl'
  # end
end
group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end

