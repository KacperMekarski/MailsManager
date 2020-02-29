source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'ar_transaction_changes'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dry-struct'
gem 'dry-types', '~> 0.12.0'
gem 'google-api-client', '~> 0.30.7'
gem 'googleauth'
gem 'paper_trail'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'wisper'
gem 'whenever', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.73.0', require: false
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'wisper-rspec', require: false
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
