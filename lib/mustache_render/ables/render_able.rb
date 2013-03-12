# -*- encoding : utf-8 -*-
#
# include MustacheRender::RenderAble
#
module MustacheRender
  module RenderAble
    class ClassMustachePopulator
      attr_reader :records_clazz

      def initialize records_clazz
        @records_clazz = records_clazz
      end

      class << self
        attr_accessor :config

        def configure
          yield self.config ||= MustachePopulatorConfig.new
        end
      end
    end

    class MustachePopulatorConfig
      def fields_filters
        @fields_filters ||= ::MustacheRender::FieldsFilterUtil.new
      end

      def fields_filters= _fitlers={}
        @fields_filters ||= ::MustacheRender::FieldsFilterUtil.new(_fitlers)
      end
    end

    class InstanceMustachePopulator
      attr_reader :record, :fields_filter
      attr_accessor :view_context

      def initialize *args, &block
        options = ::MustacheRender::ArrayUtil.extract_options!(args)

        @record = args.first

        if @record.nil?
          raise ArgumentError.new('miss first argument as record')
        end

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

      def fields_filter
        @fields_filter ||= self.class.fields_filters
      end

      private

      def impl_init_config_from_options options={}
        @view_context  = options[:view_context] if options.key?(:view_context)
        @fields_filter = options[:fields_filter] if options.key?(:fields_filter)
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

        ### 扩展类 mustache_populator ##################################
        eval <<-END_EVAL
          self.class_eval do
            def self.#{populator_name}
              @#{populator_name} ||= ::MustacheRender::RenderAble::ClassMustachePopulator.new(self)
            end

            (MustacheRender::ArrayUtil.init(#{args})).each do |populator_module|
              if populator_module.is_a?(Module)
                if defined?(populator_module::ClassMethods) && populator_module::ClassMethods.is_a?(Module)
                  self.#{populator_name}.send :extend, populator_module::ClassMethods
                end
              end
            end
          end
END_EVAL

         ### 扩展实例的populator ##############################
         eval <<-END_EVAL
            self.class_eval do
              def #{populator_name}
                return @#{populator_name} if @#{populator_name}.is_a?(::MustacheRender::RenderAble::InstanceMustachePopulator)
                @#{populator_name} ||= ::MustacheRender::RenderAble::InstanceMustachePopulator.new(self)

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

