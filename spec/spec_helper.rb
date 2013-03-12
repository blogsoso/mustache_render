require 'mustache_render'

ROOT_PATH = File.dirname(__FILE__) + '/lib'

# -*- encoding : utf-8 -*-
MustacheRender.configure do |config|
  # 默认的模板渲染媒介
  #   :file => 文件系统渲染
  config.default_render_media = :file

  # 默认的文件模板的根目录
  config.file_template_root_path = ROOT_PATH + '/resources/templates'

  # 默认的文件模板的扩展名称
  config.file_template_extension = '.mustache'

  # 当字段缺少的时候是否抛出异常
  config.raise_on_context_miss   = false

  # config.logger = Rails.logger

  config.logger.level = Logger::INFO

end
