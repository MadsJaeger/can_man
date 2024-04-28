# frozen_string_literal: true

module CanMan
  ##
  # RoutingMapper module for adding the authorize method to the routing mapper. This is to be used in the routes.rb file
  # to add authorization to the routes.
  module RoutingMapper
    def authorize(constraint, role = nil, &block)
      resolve = if constraint == :rights
                  CanMan::RightConstraint
                elsif constraint == :role
                  CanMan::RoleConstraint.for(role)
                else
                  constraint
                end

      constraints(resolve, &block)
    end
  end
end
