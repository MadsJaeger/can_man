# frozen_string_literal: true

require 'rails/generators'
require_relative './migration'

module CanMan
  module Generators
    ##
    # Adds role migration to client project
    class UninstallGenerator < Rails::Generators::Base
      TEMPLATES = [
        'drop_user_roles.rb',
        'drop_role_rights.rb',
        'drop_roles.rb',
        'drop_rights.rb',
      ].freeze

      include Migration

      desc 'Creates migration to drop tables: rights, roles, iser_rights, user_roles, and role_rights'
      source_root File.expand_path('templates', __dir__)

      def drop_migrations
        TEMPLATES.each_with_index do |file_name, leap|
          table_name = file_name.gsub('drop_', '').gsub('.rb', '')
          next unless table_exists? table_name

          template file_name, "#{migration_path(leap)}_#{file_name}"
        end
      end
    end
  end
end
