# A sample Gemfile
source "http://rubygems.org"

# require state_machine/core explicitly prevents state_machine
# to monkey patch Object class.
gem 'state_machine', :require => 'state_machine/core'

gem 'celluloid'
gem 'daemons'

gem 'log4r'

gem 'active_support', :require => 'active_support/core_ext/string/inflections'

gem 'rake'

gem 'debugger'

group :development do
  gem 'rvm-capistrano'
  #gem 'debugger'
end


group :test do
  gem 'minitest'
  gem 'ruby-prof'
end
