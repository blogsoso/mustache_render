# -*- encoding : utf-8 -*-
MustacheRender.configure do |config|
  # 默认的模板渲染媒介
  #   :db   => 数据库渲染
  #   :file => 文件系统渲染
  config.default_render_media = :db

  # 默认的文件模板的根目录
  config.file_template_root_path = "#{Rails.root}/app/templates"

  # 默认的文件模板的扩展名称
  config.file_template_extension = 'mustache'

  # 当模板缺少的时候是否抛出异常
  config.raise_on_context_miss   = false
end

