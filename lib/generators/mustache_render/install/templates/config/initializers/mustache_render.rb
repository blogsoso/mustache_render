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
end

