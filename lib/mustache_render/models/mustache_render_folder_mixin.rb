# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderFolderMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_folders'

        has_many :templates, :class_name => 'MustacheRenderTemplate', :foreign_key => 'folder_id'

        attr_accessible :parent_id, :name, :note

        acts_as_nested_set(
          :parent_column => 'parent_id',
          :left_column   => 'left_id',
          :right_column  => 'right_id',
          :depth_column  => 'depth',
          :dependent     => :delete_all, # or :destroy
          :polymorphic   => false,
          :counter_cache => 'children_count'
          #          :before_add     => :do_before_add_stuff,
          #          :after_add      => :do_after_add_stuff,
          #          :before_remove  => :do_before_remove_stuff,
          #          :after_remove   => :do_after_remove_stuff
        )

        validate                :impl_validate_full_path
        validates_presence_of   :name
        validates_uniqueness_of :full_path

        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods

      def nested_set_options(class_or_item=nil, mover = nil)
        class_or_item ||= self

        if class_or_item.is_a? Array
          items = class_or_item.reject { |e| !e.root? }
        else
          class_or_item = class_or_item.roots if class_or_item.respond_to?(:scoped)
          items = Array(class_or_item)
        end
        result = []
        items.each do |root|
          result += root.class.associate_parents(root.self_and_descendants).map do |i|
            if mover.nil? || mover.new_record? || mover.move_possible?(i)
              [yield(i), i.id]
            end
          end.compact
        end
        result
      end

      def nested_set_select_options(class_or_item=nil, mover=nil, options={})
        result = []

        result << ['- - 请选择 - -', nil] if options[:include_blank]

        result += nested_set_options(class_or_item, mover) do |item|
          "#{'- ' * item.level}#{item.name}"
        end
      end
    end

    module InstanceMethods

      protected
      def impl_generate_full_path
        tmp_parent = self.class.find_by_id self.parent_id

        if tmp_parent
          "/#{tmp_parent.self_and_ancestors.map(&:name).join('/')}/#{self.name}"
        else
          "/#{self.name}"
        end
      end

      def impl_validate_full_path
        self.full_path = impl_generate_full_path
      end

      private

      #      def do_before_add_stuff(child_node)
      #        # do whatever with the child
      #      end
      #
      #      def do_after_add_stuff(child_node)
      #        # do whatever with the child
      #      end
      #
      #      def do_before_remove_stuff(child_node)
      #        # do whatever with the child
      #      end
      #
      #      def do_after_remove_stuff(child_node)
      #        # do whatever with the child
      #      end
    end
  end
end
