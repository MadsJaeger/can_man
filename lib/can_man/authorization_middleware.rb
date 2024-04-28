# frozen_string_literal: true

module CanMan
  ##
  # Middleware to catch unauthorized requests. This middleware is automatically added to the middleware stack. If
  # :can_man is thrown, the request is halted and the FailureApp is called. This is to be used with the
  # CanMan::Constraint doing the actual authorization, throwing :can_man.
  class AuthorizationMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      catch(:can_man) { @app.call(env) } || CanMan::FailureApp.action(:index).call(env)
    end
  end
end
