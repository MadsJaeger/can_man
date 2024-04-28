# frozen_string_literal: true

module CanMan
  ##
  # A key is a string that represents a controller action. It is in the format of 'controller#action'.
  # The key can also be in the format of 'controller#*' or '*#action' to represent all actions in a
  # controller or all controllers in an action respectively.
  class Key < String
    REGEX = /\A[a-z0-9_\/\*]+#[a-z0-9_\*]+\z/i

    def initialize(string = '', controller: nil, action: nil)
      if controller.present? && action.present?
        super("#{controller}##{action}")
      else
        super(string)
      end
    end

    def controller
      split('#').first
    end

    def action
      split('#').second
    end

    def any_action?
      action == '*'
    end

    def any_controller?
      controller == '*'
    end
  end
end
