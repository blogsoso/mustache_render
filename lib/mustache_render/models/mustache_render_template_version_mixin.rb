# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateVersionMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_template_versions'

        attr_accessible :folder_id, :name, :note, :content, :template_id, :user_id, :full_path

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
    end
  end
end

