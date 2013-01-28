# -*- encoding : utf-8 -*-
module MustacheRender
  class PopulatorBase
    attr_reader :data

    def initialize options={}
      @context  = options[:context]
      @data     = ::MustacheRender::Mustache::Data.new
      @template = options[:template]
      @_scope    = options[:scope]
      @_method   = options[:method] || "#{@context.controller_name}_#{@context.action_name}"

      self.send _impl_get_render_method_name
    end

    #
    # impl_collect_reader_board
    #
    def collect_record record_name, record, options={}, &block
      if record
        result = self.send("impl_collect_#{record_name}".to_sym, record, options, &block) || {}
        result = _impl_collect_require_fields(result, record_name, record, options, &block)
        result
      else
        {
          'miss?' => true
        }
      end
    end

    def collect_records record_name, records, options={}, &block
      records.map do |record|
        collect_record record_name, record, options, &block
      end
    end

    #
    #   render template
    #   file_render template_path
    #   db_render   template_path
    #
    [:render, :file_render, :db_render, :impl_render].each do |method_name|
      define_method method_name do |path_or_template=nil|
        @context.send "mustache_#{method_name}".to_sym, "#{path_or_template || @template}", @data
      end
    end

    private

    def _impl_collect_require_fields result, record_name, record, options={}
      _cache_names = {}

      (options[:fields] || []).each do |field|
        formated_method_name = "format_field_#{record_name}_#{field}".to_sym

        if self.respond_to?(formated_method_name)
          (result[:fields] ||= {}).merge!(
            field => self.send(formated_method_name, record, options)
          )
        elsif record.respond_to?(field)
          (result[:fields] ||= {}).merge!(
            field => record.send(field)
          )
        else
          raise "#{self.class.to_s} not define method: #{formated_method_name} or #{record_name} can not respond_to: #{field}"
        end
      end

      result
    end


    def _impl_get_render_method_name
      "render#{"_#{@_scope}" if @scope.present?}_#{@_method}"
    end

    class << self
      #
      # 定义了
      #
      [:render, :file_render, :db_render, :impl_render].each do |method_name|
        define_method method_name do |options={}|
          self.new(options).send method_name
        end
      end
    end

  end
end
