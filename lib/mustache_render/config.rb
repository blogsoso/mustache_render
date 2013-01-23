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
<<<<<<< HEAD
      @default_render_media ||= :db
=======
      @default_render_media ||= :file
>>>>>>> 470b53b7c4b5e433b72058d09dcf680f63b76f80
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

    def cache
      return @_cache_store if defined?(@_cache_store)

      @_cache_store ||= Rails.cache
      # @_cache_store ||= MemCache.new('localhost:11211', :namespace => 'mustache_render#cache')
    end

    def cache_store= cache_store
      @_cache_store ||= cache_store
    end

<<<<<<< HEAD
=======
    def logger
      return @_logger if defined?(@_logger)

      @_logger ||= ::Logger.new(STDOUT)
    end

    def logger= logger
      @_logger ||= logger
    end

>>>>>>> 470b53b7c4b5e433b72058d09dcf680f63b76f80
    #
    # 是否开启缓存
    #
    def db_template_cache?
      if defined?(@_db_template_cache)
        @_db_template_cache
      else
        true
      end
    end

    #
    # 是否开启缓存
    #
    def file_template_cache?
      if defined?(@_file_template_cache)
        @_file_template_cache
      else
        false
      end
    end

    #
    # 设置是否启用缓存
    #
    def db_template_cache= user_cache
      @_db_template_cache = user_cache unless defined?(@_db_template_cache)
    end

    #
    # 设置是否启用缓存
    #
    def file_template_cache= user_cache
      @_file_template_cache = user_cache unless defined?(@_file_template_cache)
    end

    def db_template_cache_expires_in
      @db_template_cache_expires_in ||= 1.hours
    end

    def file_template_cache_expires_in
      @file_template_cache_expires_in ||= 5.minutes
    end

    def db_template_cache_expires_in= expires_in
      @db_template_cache_expires_in ||= expires_in
    end

    def file_template_cache_expires_in= expires_in
      @file_template_cache_expires_in ||= expires_in
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

    def db_template_extension
      @db_template_extension ||= '.mustache'
    end

    def db_template_extension= name
      @db_template_extension ||= name
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

    # 是否抛出数据库模板miss的异常
    def raise_on_db_template_miss= _bool
      @raise_on_db_template_miss = _bool unless defined?(@raise_on_db_template_miss)
    end

    def raise_on_db_template_miss?
      defined?(@raise_on_db_template_miss) ? @raise_on_db_template_miss : true
    end

    def raise_on_context_miss?
      defined?(@raise_on_context_miss) ? @raise_on_context_miss : false
    end

    def raise_on_context_miss=(_bool)
      @raise_on_context_miss = _bool unless defined?(@raise_on_context_miss)
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
