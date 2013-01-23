# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateVersionMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_template_versions'
        record_timestamps = false

        attr_accessible :folder_id, :name, :note, :content, :last_user_id, :create_user_id,
          :full_path, :created_at, :updated_at, :template_id, :change_log

        belongs_to :folder,   :class_name => 'MustacheRenderFolder'
        belongs_to :template, :class_name => 'MustacheRenderTemplate'

        validates_presence_of   :template_id

        # validates_presence_of   :folder_id
        # validates_presence_of   :name

        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      #
      # 还原这个版本
      #
      def revert
        self.template.update_attributes(
          :folder_id      => self.folder_id,
          :name           => self.name,
          :content        => self.content,
          :note           => self.note,
          :last_user_id   => self.last_user_id,
          :create_user_id => self.create_user_id,
          :change_log     => "【last version: #{self.id} #{self.change_log}】"
        )
      end
    end
  end
end

