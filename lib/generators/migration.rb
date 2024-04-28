# frozen_string_literal: true

require 'active_record'

module CanMan
  module Generators
    ##
    # Mixin to generators resolving migration path and version
    module Migration
      private

      def table_exists?(table_name)
        ActiveRecord::Base.connection.table_exists? table_name
      end

      def migration_path(leap = 0)
        ::Rails.root.join("db/migrate/#{(Time.zone.now + leap.seconds).strftime('%Y%m%d%H%M%S')}")
      end

      def migration_version
        "[#{ActiveRecord::Migration.current_version}]"
      end
    end
  end
end
