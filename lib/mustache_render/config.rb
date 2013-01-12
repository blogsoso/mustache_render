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

    # 配置适配器
    def adapter_configure(&block)
      ::MustacheRender.adapter_configure do |adapter|
        if block_given?
          block.call adapter
        end
      end
    end

    #
    # 默认的渲染媒介
    #
    def default_render_media
      @default_render_media ||= :db
    end

    def default_render_media= media
      @default_render_media ||= media
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
      @file_template_extension ||= 'mustache'
    end

    def file_template_extension= name
      @file_template_extension ||= name
    end

    def raise_on_context_miss?
      defined?(@raise_on_context_miss) ? @raise_on_context_miss : false
    end

    def raise_on_context_miss=(boolean)
      @raise_on_context_miss = boolean
    end

    def manager_view_base
      @manager_view_base ||= {
        :title => "MustacheRender Manager Center"
      }.merge(@_manager_view_base || {})
    end

    def manager_view_base= options={}
      @_manager_view_base = options
    end

  end
end
