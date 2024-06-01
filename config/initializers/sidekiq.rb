Sidekiq.configure_server do |config|
  config.redis = {url: ENV["REDIS_URL"]}
  config.redis = {db: 1}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["REDIS_URL"]}
  config.redis = {db: 1}
end
