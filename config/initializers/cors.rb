Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins /\Ahttp:\/\/localhost(:\d+)?\z/, /\A.*[.]unityroom.com\z/

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
