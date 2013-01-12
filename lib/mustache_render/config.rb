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

    def manager_authenticate_fail_url
      @manager_authenticate_fail_url ||= '/login'
    end

    def manager_authenticate_fail_url= url
      @manager_authenticate_fail_url ||= url
    end

    def user_login_url
      @user_login_url ||= '/login'
    end

    def user_login_url= url
      @user_login_url ||= url
    end

    def manage_center_need_login?
      if defined?(@manage_center_need_login)
        @manage_center_need_login
      else
        true
      end
    end

    ## 管理中心是否需要登录 ？
    def manage_center_need_login= value
      @manage_center_need_login = value unless defined?(@manage_center_need_login)
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

    def manage_view_base
      @manage_view_base ||= {
        :title => "MustacheRender Manage Center"
      }.merge(@_manage_view_base || {})
    end

    def manage_view_base= options={}
      @_manage_view_base = options
    end

  end
end
