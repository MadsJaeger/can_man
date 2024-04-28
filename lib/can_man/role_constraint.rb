module CanMan
  ##
  # Routing constraint to check if current use has the given role.
  class RoleConstraint
    class << self
      def for(role)
        new(role)
      end
    end

    attr_accessor :request, :role

    delegate :params, to: :request
    delegate :env, to: :request

    def initialize(role)
      self.role = role
    end

    def matches?(request)
      self.request = request
      can_man_access?
    end

    def can_man_access?
      throw(:can_man, false) unless current_user&.has_role?(@role)
      true
    end

    def current_user
      env.fetch('warden').user
    end
  end
end
