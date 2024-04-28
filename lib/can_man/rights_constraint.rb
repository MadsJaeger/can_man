module CanMan
  ##
  # Routing constraint to check if current use has right to access current controller#action.
  class RightConstraint
    class << self
      def matches?(request)
        new(request).can_man_access?
      end
    end

    attr_accessor :request

    delegate :params, to: :request
    delegate :env, to: :request

    def initialize(request)
      self.request = request
    end

    def can_man_access?
      throw(:can_man, false) unless current_user&.has_right?(key)
      true
    end

    def current_user
      env.fetch('warden').user
    end

    def controller
      params.fetch(:controller)
    end

    def action
      params.fetch(:action)
    end

    def key
      Key.new(controller: controller, action: action)
    end
  end
end
