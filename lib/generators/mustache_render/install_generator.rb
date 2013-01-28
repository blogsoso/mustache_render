# -*- encoding : utf-8 -*-
require 'rails/generators'
require 'rails/generators/migration'

module MustacheRender
    class InstallGenerator < Rails::Generators::Base
      desc "Generates MustacheRender"

      def copy_files
        template "config/initializers/mustache_render.rb", "config/initializers/mustache_render.rb"
      end

      def self.orm
        Rails::Generators.options[:rails][:orm]
      end

      def self.source_root
        File.join(File.dirname(__FILE__), 'install', 'templates')
      end

      def self.orm_has_migration?
        [:active_record].include? orm
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          migration_number += 1
          migration_number.to_s
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      private

      def copy_model(orm, name)
        template "models/#{orm}/#{name}.rb", "app/models/#{name}.rb"
      end
    end
  end
