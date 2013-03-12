# -*- encoding : utf-8 -*-
module MustacheRender
  class << self
    attr_accessor :config

    def configure
      yield self.config ||= Config.new
    end
  end

  class Config
    def initialize
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

    def logger
      return @_logger if defined?(@_logger)

      require 'logger'
      @_logger ||= ::Logger.new(STDOUT)
    end

    def logger= logger
      @_logger ||= logger
    end

    def raise_on_context_miss?
      return @_raise_on_context_miss if defined?(@_raise_on_context_miss)

      @raise_on_context_miss = false
    end

    def raise_on_context_miss= _miss
      return @_raise_on_context_miss if defined?(@_raise_on_context_miss)

      @raise_on_context_miss = _miss
    end

    def raise_on_file_template_miss?
      return @_raise_on_file_template_miss if defined?(@_raise_on_file_template_miss)

      @raise_on_file_template_miss = true
    end

    def raise_on_file_template_miss= _miss
      return @_raise_on_file_template_miss if defined?(@_raise_on_file_template_miss)

      @raise_on_file_template_miss = _miss
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

  end
end
