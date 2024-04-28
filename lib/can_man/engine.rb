# frozen_string_literal: true

require 'rails/engine'

module CanMan
  # :nodoc:
  class Engine < ::Rails::Engine
    ##
    # Engine has not been isolated
    # isolate_namespace CanMan

    config.to_prepare do
      if Rails.application.config.middleware.middlewares.include?(CanMan::AuthorizationMiddleware)
        ActionDispatch::Routing::Mapper.class_eval do
          include CanMan::RoutingMapper
        end
      end
    end
  end
end
