if defined?(Rack::Timeout)
  Rack::Timeout.service_timeout = 30
  Rack::Timeout.wait_timeout = 60
end
