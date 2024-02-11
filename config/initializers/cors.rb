Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: false, logger: (-> { Rails.logger }) do
  cors_origins = ENV.fetch("CORS_ORIGINS", "localhost:3000")

  if cors_origins && cors_origins != "*"
    allow do
      origins(*cors_origins.split(",").map(&:strip))

      resource "/api/*",
        headers: :any,
        methods: [:get, :post, :delete, :put, :patch, :options, :head],
        max_age: 0,
        credentials: true
    end
  end
end
