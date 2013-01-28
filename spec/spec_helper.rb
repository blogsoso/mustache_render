# -*- encoding : utf-8 -*-
require 'mustache_render'


ROOT_PATH = File.dirname(__FILE__) + '/lib'

# -*- encoding : utf-8 -*-
MustacheRender.configure do |config|
  # 默认的模板渲染媒介
  #   :db   => 数据库渲染
  #   :file => 文件系统渲染
  config.default_render_media = :db

  # 默认的文件模板的根目录
  config.file_template_root_path = ROOT_PATH + '/resources/templates'

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

  # config.logger = Rails.logger

  config.logger.level = Logger::INFO

  ### 模板的相关配置 ###########################
  # 缓存的媒介
  # config.cache_store                    = Rails.cache

  # 版本适配器的配置
  config.adapter_configure do |adapter|

  end

  # config.manage_center_need_login      = true
  config.manage_center_need_login      = false
  config.user_login_url             = '/login'
  config.manager_authenticate_fail_url = '/auth_fail'
end



