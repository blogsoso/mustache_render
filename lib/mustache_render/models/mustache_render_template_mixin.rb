# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderTemplateMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_templates'

        attr_accessible :folder_id, :name, :note, :content, :last_user_id, :create_user_id, :change_log

        attr_accessor   :change_log

        belongs_to :folder,            :class_name => 'MustacheRenderFolder'
        has_many   :template_versions,
          :class_name  => 'MustacheRenderTemplateVersion',
          :foreign_key => 'template_id',
          :order       => 'mustache_render_template_versions.updated_at DESC'

        before_update :create_new_version

        validates_presence_of   :folder_id
        validates_presence_of   :name
        validates_presence_of   :change_log, :if => Proc.new { |r| !(r.new_record?) }

        validate do |r|
          r.errors.add :change, '没有改动' if !(r.new_record?) && !(r.changed?)
        end

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

      def folder_was
        MustacheRenderFolder.find_by_id self.folder_id_was
      end

      def full_path_was
        "#{self.folder_was.try :full_path}/#{self.name_was}"
      end

      def create_new_version
        # 如果有修改，则记录一个版本
        if self.valid? && self.changed?
          self.template_versions.create(
            :template_id    => self.id,
            :folder_id      => self.folder_id_was,
            :name           => self.name_was,
            :content        => self.content_was,
            :full_path      => self.full_path_was,
            :note           => self.note_was,
            :last_user_id   => self.last_user_id_was,
            :create_user_id => self.create_user_id_was,
            :created_at     => self.created_at_was,
            :updated_at     => self.updated_at_was,
            :change_log     => self.change_log
          )
        end
      end
    end
  end
end

