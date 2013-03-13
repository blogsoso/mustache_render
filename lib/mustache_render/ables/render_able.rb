# -*- encoding : utf-8 -*-
module MustacheRender
  module RenderAble
    class MustachePopulatorConfig
      def filters_util
        @filters_util ||= ::MustacheRender::FieldsFilterUtil.new
      end

      def filters_util= options={}
        @filters_util ||= ::MustacheRender::FieldsFilterUtil.new(options)
      end
    end

    module SharedMethods
      [:render, :file_render].each do |_render_method|
        define_method "mustache_#{_render_method}" do |*args, &block|
          options = ::MustacheRender::ArrayUtil.extract_options!(args)
          template_or_path = args.first || ''
          ::MustacheRender::Mustache.send(_render_method, template_or_path, self.to_mustache(options, &block))
        end
      end
    end

    module ForRecord
      def self.included base
        base.class_eval do
          include ::MustacheRender::RenderAble::SharedMethods
          extend  ClassMethods
          include InstanceMethods
        end
      end

      # 类方法
      module ClassMethods
        def load_mustache_populator *args, &block
          options = ::MustacheRender::ArrayUtil.extract_options!(args)
          populator_moules = args # 组装器

          populator_moules.each do |populator_moule|
            self.send :include, populator_moule if populator_moule.is_a?(Module)
          end

          if block_given?
            block.call(
              self.mustache_populator_config
            )
          end
        end

        def mustache_populator_config
          @mustache_populator_config ||= ::MustacheRender::RenderAble::MustachePopulatorConfig.new
        end
      end

      module InstanceMethods
        def mustache_populator_config
          self.class.mustache_populator_config
        end

        def to_mustache *args, &block
          options = ::MustacheRender::ArrayUtil.extract_options!(args)
          populator_name = args.first || :default

          result = ::MustacheRender::Mustache::Data.new(
            :nil? => false
          )

          filter_util = self.mustache_populator_config.filters_util.load(options[:filter] || :default)

          self.impl_to_mustache result, filter_util, options, &block if defined?(self.impl_to_mustache)

          if block_given?
            if(_block_result = block.call result).is_a?(::Hash)
              result.merge! _block_result
            end
          end

          result
        end
      end
    end

    module ForList
      include ::MustacheRender::RenderAble::SharedMethods

      def to_mustache *args, &block
        options = ::MustacheRender::ArrayUtil.extract_options!(args)

        result = {
          :any? => self.any?,
          :list => self.map do |item|
            item.to_mustache *args, &block
          end
        }

        # 支持分页？
        if self.respond_to?(:total_entries)
          pagination_result = {
            :support? => true,
            :info     => {
              :current_page  => self.current_page,                     # 当前页数
              :total_entries => self.total_entries,                    # 总页数
              :per_page      => self.per_page,                         # 每页条数
              :total_pages   => self.total_pages,                      # 总页数
              :first_page?   => self.current_page == 1,                # 是否是第一页?
              :last_page?    => self.current_page == self.total_pages, # 最后一页?
              :next_page     => self.next_page,                        # 下一页
              :previous_page => self.previous_page                     # 前一页
            }
          }
        else
          pagination_result = {
            :support? => false
          }
        end

        result.merge!(
          :pagination => pagination_result
        )

        result
      end
    end

    module NilMethods
      def to_mustache options={}
        ::MustacheRender::Mustache::Data.new(
          :nil? => true
        )
      end
    end
  end
end

if defined?(::NilClass)
  ::NilClass.send :include, ::MustacheRender::RenderAble::NilMethods
end

