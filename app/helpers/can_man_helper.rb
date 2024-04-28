# frozen_string_literal: true

##
# View helpers for CanMan. Allows view to resolve wheter a user has access to a certain controller action
# or not. This is useful for not rendering links and actions that the user has no access to.
module CanManHelper
  delegate :has_right?, :has_role?, to: :@current_user
end
