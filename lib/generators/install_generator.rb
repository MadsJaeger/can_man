# frozen_string_literal: true

require 'rails/generators'
require_relative './migration'

module CanMan
  module Generators
    ##
    # Adds role migration to client project
    class InstallGenerator < Rails::Generators::Base
      include Migration

      desc 'Creates migration to create rights, roles and role_rights tables'
      source_root File.expand_path('templates', __dir__)

      def add_migrations
        %w[
          create_rights.rb
          create_roles.rb
          create_role_rights.rb
          create_user_roles.rb
        ].each_with_index do |file_name, leap|
          template file_name, "#{migration_path(leap)}_#{file_name}"
        end
      end
    end
  end
end
