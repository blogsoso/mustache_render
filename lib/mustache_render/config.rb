# -*- encoding : utf-8 -*-
module MustacheRender
  class << self
    attr_accessor :config

    def configure
      yield self.config ||= Config.new
      self.config.apply!
    end
  end

  class Config
    def apply!
      #  if self.action_view_handler?
      #    if defined?(::ActionView::Template)
      #      ::ActionView::Template.register_template_handler(
      #        self.action_view_handler_extension.to_sym,
      #        ::MustacheRender::CoreExt::ActionViewHandler
      #      )
      #    end
      #  end
    end

    def initialize
    end

    # 配置适配器
    def adapter_configure(&block)
      ::MustacheRender.adapter_configure do |adapter|
        if block_given?
          block.call adapter
        end
      end
    end

    def action_view_handler?
      if defined?(@_use_action_view_handler)
        @_use_action_view_handler
      else
        true
      end
    end

    def use_action_view_handler= _bool
      @_use_action_view_handler = _bool unless defined?(@_use_action_view_handler)
    end

    #
    # 默认的渲染媒介
    #
    def default_render_media
      @default_render_media ||= :file
    end

    def default_render_media= media
      @default_render_media ||= media
    end

    # def cache
    #   return @_cache_store if defined?(@_cache_store)

    #   @_cache_store ||= Rails.cache
    #   # @_cache_store ||= MemCache.new('localhost:11211', :namespace => 'mustache_render#cache')
    # end

    # def cache_store= cache_store
    #   @_cache_store ||= cache_store
    # end

    def logger
      return @_logger if defined?(@_logger)

      require 'logger'

      @_logger ||= ::Logger.new(STDOUT)
    end

    def logger= logger
      @_logger ||= logger
    end

    #
    # lib 的基本路径
    #
    def lib_base_path
      File.dirname(__FILE__)
    end

    def file_template_root_path
      @file_template_root_path ||= "#{lib_base_path}/mustache_render/templates"
    end

    def file_template_root_path= path
      @file_template_root_path ||= path
    end

    def file_template_extension
      @file_template_extension ||= '.mustache'
    end

    def file_template_extension= name
      @file_template_extension ||= name
    end

    # 是否抛出文件模板丢失的异常？
    def raise_on_file_template_miss= _bool
      @raise_on_file_template_miss = _bool unless defined?(@raise_on_file_template_miss)
    end

    def raise_on_file_template_miss?
      defined?(@raise_on_file_template_miss) ? @raise_on_file_template_miss : true
    end

    def raise_on_context_miss?
      defined?(@raise_on_context_miss) ? @raise_on_context_miss : false
    end

    def raise_on_context_miss=(_bool)
      @raise_on_context_miss = _bool unless defined?(@raise_on_context_miss)
    end
  end
end

