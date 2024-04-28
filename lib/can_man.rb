# frozen_string_literal: true

require 'can_man/version'
require 'can_man/engine'
require 'can_man/key'
require 'can_man/user_rights'
require 'can_man/authorization_middleware'
require 'can_man/failure_app'
require 'can_man/rights_constraint'
require 'can_man/role_constraint'
require 'can_man/authorize'
require 'can_man/routing_mapper'

require 'generators/install_generator'
require 'generators/uninstall_generator'

# :nodoc:
module CanMan
end
