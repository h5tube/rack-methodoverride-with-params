require 'rack'

module Rack
  class MethodOverrideWithParams < Rack::MethodOverride
    def initialize(app, opts={})
      @app = app
      @opts = opts
    end

    def call(env)
      if @opts[:override_any_method] ||
              env["REQUEST_METHOD"] == "POST"
        req = Request.new(env)
        method = req.params[METHOD_OVERRIDE_PARAM_KEY] ||
          env[HTTP_METHOD_OVERRIDE_HEADER]
        method = method.to_s.upcase
        if HTTP_METHODS.include?(method)
          env["rack.methodoverride.original_method"] = env["REQUEST_METHOD"]
          env["REQUEST_METHOD"] = method
        end
      end

      @app.call(env)

    end
  end
end
