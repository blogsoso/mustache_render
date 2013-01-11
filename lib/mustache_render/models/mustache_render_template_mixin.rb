# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_templates'

        attr_accessible :folder_id, :name, :note, :content

        belongs_to :folder, :class_name => 'MustacheRenderFolder'

        validate                :impl_generate_full_path

        validates_presence_of   :folder_id
        validates_presence_of   :full_path
        validates_presence_of   :name

        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods

    end

    module InstanceMethods
      protected

      private

      def impl_generate_full_path
        self.full_path = self.folder.try :full_path
      end
    end
  end
end

