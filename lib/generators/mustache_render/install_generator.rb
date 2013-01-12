# -*- encoding : utf-8 -*-
require 'rails/generators'
require 'rails/generators/migration'

module MustacheRender
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Generates MustacheRender database migration, models"

      def copy_files
        orm = options[:orm].to_s
        orm = "active_record" unless %w{active_record}.include?(orm)
        %w(mustache_render_folder mustache_render_template mustache_render_manager).each do |file|
          copy_model(orm, file)
        end

        template "config/initializers/mustache_render.rb", "config/initializers/mustache_render.rb"

        if self.class.orm_has_migration?
          migration_template "#{orm}/migration.rb", 'db/migrate/mustache_render_migration'
        end
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
