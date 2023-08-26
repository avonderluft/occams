# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

group :development, :test do
  gem 'autoprefixer-rails', '~> 8.1.0'
  gem 'byebug',             '~> 10.0.0', platforms: %i[mri mingw x64_mingw]
  gem 'capybara',           '~> 3.39.0'
  gem 'image_processing',   '>= 1.2'
  gem 'kaminari',           '~> 1.2', '>= 1.2.2'
  gem 'puma',               '~> 3.12.2'
  gem 'rubocop',            '~> 0.55.0', require: false
  gem 'selenium-webdriver', '~> 4.9.0'
  gem 'sqlite3',            '~> 1.4.2'
end

group :development do
  gem 'listen',       '~> 3.8.0'
  gem 'web-console',  '~> 4.2'
end

group :test do
  gem 'coveralls',                '~> 0.8.23', require: false
  gem 'diffy',                    '~> 3.4.2'
  gem 'equivalent-xml',           '~> 0.6.0'
  gem 'mocha',                    '~> 2.1.0', require: false
  gem 'rails-controller-testing', '~> 1.0.5'
end
