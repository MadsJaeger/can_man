# frozen_string_literal: true

module CanMan
  ##
  # Authorize module for controllers. Whence included a before_action is added to the controller to check if the user
  # has access to the requested controller action. If not, the request is halted and the FailureApp is called. I.e.
  # middleware has to be added to the middleware stack for this to succeed.
  module Authorize
    def self.included(base)
      base.before_action :can_man_access!
    end

    def can_man_access!
      can_man_access? || throw(:can_man, false)
    end

    def can_man_access?
      current_user&.has_right?(Key.new(controller: params[:controller], action: params[:action]))
    end
  end
end
