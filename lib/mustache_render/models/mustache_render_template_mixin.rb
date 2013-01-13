# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_templates'

        attr_accessible :folder_id, :name, :note, :content

        belongs_to :folder,            :class_name => 'MustacheRenderFolder'
        has_many   :template_versions,
          :class_name  => 'MustacheRenderTemplateVersion',
          :foreign_key => 'template_id',
          :order       => 'mustache_render_template_versions.created_at DESC'

        validates_presence_of   :folder_id
        validates_presence_of   :name

        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      #
      # TODO: add cache here!
      #
      def find_with_full_path(name)
        # 首先获取文件夹的名称, 然后获取文件名
        tmp_paths = name.to_s.split('/')

        template_name = tmp_paths.pop.to_s

        folder_full_path = "#{tmp_paths.join('/')}"
        folder = ::MustacheRenderFolder.find_by_full_path(folder_full_path)

        self.find_by_folder_id_and_name(folder.try(:id), template_name)
      end
    end

    module InstanceMethods
      def full_path
        "#{self.folder.try :full_path}/#{self.name}"
      end

      def create_new_version(options={})
        # 如果有修改，则记录一个版本
        # if self.changed?
          #      t.integer :template_id                 # 模板的id
          #      t.integer :user_id                     # 用户ID
          #      t.integer :folder_id                   # 文件夹的ID
          #      t.string  :name                        # 模板的名称
          #      t.text    :content                     # 代码
          #      t.string  :full_path
          #
          #      t.text    :note                        # 备注

          self.template_versions.create(
            :template_id => self.id,
            :folder_id   => self.folder_id,
            :name        => self.name,
            :content     => self.content,
            :full_path   => self.full_path,
            :note        => self.note,
            :user_id     => options[:user_id]
          )
        # end
      end
    end
  end
end

