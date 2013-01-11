# -*- encoding : utf-8 -*-
require 'mustache_render/config'

module MustacheRender

  module Manager
    autoload :BaseController,      'mustache_render/controllers/mustache_render/manager/base_controller'
    autoload :FoldersController,   'mustache_render/controllers/mustache_render/manager/folders_controller'
    autoload :TemplatesController, 'mustache_render/controllers/mustache_render/manager/templates_controller'
  end

  module CoreExt
    autoload :MustacheExt,       'mustache_render/core_ext/mustache_ext'
    autoload :BaseControllerExt, 'mustache_render/core_ext/base_controller_ext'
  end

  module Controllers
  end

  module Models
    autoload :MustacheRenderFolderMixin,   'mustache_render/models/mustache_render_folder_mixin'
    autoload :MustacheRenderTemplateMixin, 'mustache_render/models/mustache_render_template_mixin'
  end
end

if defined?(::Mustache)
  ::Mustache.send :include, ::MustacheRender::CoreExt::MustacheExt
end

if defined?(::ActionController::Base)
  ::ActionController::Base.send :include, ::MustacheRender::CoreExt::BaseControllerExt
end

