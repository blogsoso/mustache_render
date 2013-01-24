# -*- encoding : utf-8 -*-
MustacheRender.configure do |config|
  # 默认的模板渲染媒介
  #   :db   => 数据库渲染
  #   :file => 文件系统渲染
  config.default_render_media = :db

  # 默认的文件模板的根目录
  config.file_template_root_path = "#{Rails.root}/app/templates"

  # 默认的文件模板的扩展名称
  config.file_template_extension = '.mustache'

  # 默认的数据模板的扩展名称
  config.db_template_extension   = '.mustache'

  # 当字段缺少的时候是否抛出异常
  config.raise_on_context_miss   = false

  # 当数据库模板不存在时候是否抛出异常
  config.raise_on_db_template_miss   = true

  # 当文件模板不存在时候是否抛出异常
  config.raise_on_file_template_miss = true

  config.logger = Rails.logger

  ### 模板的相关配置 ###########################
  # # 数据库模板是否需要缓存
  # config.db_template_cache   = true
  # # 文件模板是否需要缓存
  # config.file_template_cache = false
  # # 数据库模板缓存过期时间
  # config.db_template_cache_expires_in   = 1.hours
  # # 文件模板缓存的过期时间, 注意文件系统没有自动清理缓存的机制，建议设置的短一些
  # config.file_template_cache_expires_in = 1.minutes
  # # 缓存的媒介
  # config.cache_store                    = Rails.cache

  # 版本适配器的配置
  config.adapter_configure do |adapter|

  end

  # 管理中心是否需要登录
  config.manage_center_need_login      = true
  # 用户登录的url
  config.user_login_url             = '/login'
  # 管理员登录失败后跳往的URL
  config.manager_authenticate_fail_url = '/login'

end

