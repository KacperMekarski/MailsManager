**dependencies**:

Ruby 2.6.1

Rails 5.2.2

Postgresql 10.9

**Quick start**:

```
bundle install
docker-compose -f docker_compose.dev.yml up -d
RAILS_ENV=test bundle exec rake db:setup
bundle exec rake db:setup
```

**run tests**:

`bundle exec rspec spec`

**run server**:

`rails server`
