# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_templates'

        attr_accessible :folder_id, :name, :note, :content

        belongs_to :folder, :class_name => 'MustacheRenderFolder'

        validates_presence_of   :folder_id
        validates_presence_of   :name

        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def find_with_full_path(name)
        # 首先获取文件夹的名称, 然后获取文件名
        tmp_paths = name.to_s.split('/')

        template_name = tmp_paths.pop.to_s

        folder_full_path = "#{tmp_paths.join('/')}"
        folder = ::MustacheRenderFolder.find_by_full_path(folder_full_path)

        if folder
          self.find_by_folder_id_and_name(folder.try(:id), template_name)
        end
      end
    end

    module InstanceMethods
      def full_path
        "#{self.folder.try :full_path}/#{self.name}"
      end
    end
  end
end

