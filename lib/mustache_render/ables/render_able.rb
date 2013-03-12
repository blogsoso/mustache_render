# -*- encoding : utf-8 -*-
#
# include MustacheRender::RenderAble
#
module MustacheRender
  module RenderAble
    class InstanceMustachePopulator
      attr_reader :record, :fields_filters
      attr_accessor :view_context

      def initialize *args, &block
        options = ::MustacheRender::ArrayUtil.extract_options!(args)

        @record = args.first

        if @record.nil?
          raise ArgumentError.new('miss first argument as record')
        end

        # 过滤条件
        if options[:fields_filters].is_a?(::MustacheRender::FieldsFilterUtil)
          @fields_filters = options[:fields_filters]
        elsif options[:fields_filters].is_a?(::Hash)
          @fields_filters = ::MustacheRender::FieldsFilterUtil.new(
            options[:fields_filters]
          )
        else
          @fields_filters = ::MustacheRender::FieldsFilterUtil.new
        end

        @fields_filters.freeze
      end

      def to_mustache options={}, &block

        result = ::MustacheRender::Mustache::Data.new(
          :miss? => false
        )

        self.send :impl_to_mustache, result, options, &block if defined?(impl_to_mustache)

        if block_given?
          if(_block_result = block.call result).is_a?(Hash)
            result.merge! _block_result
          end
        end

        case result
        when ::MustacheRender::Mustache::Data
          result
        when ::Hash
          ::MustacheRender::Mustache.new result
        else
          ::MustacheRender::Mustache.new {}
        end
      end

      private

      def impl_init_config_from_options options={}
        @view_context   = options[:view_context] if options.key?(:view_context)
      end

    end

    def self.included base
      base.class_eval do
        extend ClassExtendsMethods
      end
    end

    module ClassExtendsMethods
      # 加载组装器
      def load_musatche_populator *args, &block
        options = ::MustacheRender::ArrayUtil.extract_options!(args)

        # 加载实例的 to_mustache 方法等
        args.each do |populator_module|
          self.send :include, populator_module if populator_module.is_a?(Module)
        end

        populator_name = [String, Symbol].include?(args.first) ? args.first.to_s : 'mustache_populator'

        _fields_filters_options = { :fields_filters => options[:fields_filters] }

        ### 扩展实例的populator ##############################
        eval <<-END_EVAL
            self.class_eval do
              def #{populator_name}
                return @#{populator_name} if @#{populator_name}.is_a?(::MustacheRender::RenderAble::InstanceMustachePopulator)
                @#{populator_name} ||= ::MustacheRender::RenderAble::InstanceMustachePopulator.new(
                  self, #{_fields_filters_options}
                )

                (MustacheRender::ArrayUtil.init(#{args})).each do |populator_module|
                  if defined?(populator_module::InstanceMethods) && populator_module::InstanceMethods.is_a?(Module)
                    @#{populator_name}.send :extend, populator_module::InstanceMethods
                  end
                end

                @#{populator_name}
              end
            end
END_EVAL

      end
    end

    module MissingMethods
      def to_mustache options={}
        ::MustacheRender::Mustache::Data.new(
          :miss? => true
        )
      end
    end

  end
end

::NilClass.send :include, ::MustacheRender::RenderAble::MissingMethods

