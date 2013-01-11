# -*- encoding : utf-8 -*-
require 'mustache_render/config'
require 'mustache_render/mustache'

module MustacheRender
  module Manager
    autoload :BaseController,      'mustache_render/controllers/mustache_render/manager/base_controller'
    autoload :FoldersController,   'mustache_render/controllers/mustache_render/manager/folders_controller'
    autoload :TemplatesController, 'mustache_render/controllers/mustache_render/manager/templates_controller'
  end

  module CoreExt
    autoload :BaseControllerExt,   'mustache_render/core_ext/base_controller_ext'
  end

  module Controllers
  end

  module Models
    autoload :MustacheRenderFolderMixin,   'mustache_render/models/mustache_render_folder_mixin'
    autoload :MustacheRenderTemplateMixin, 'mustache_render/models/mustache_render_template_mixin'
  end
end

if defined?(::ActionController::Base)
  ::ActionController::Base.send :include, ::MustacheRender::CoreExt::BaseControllerExt
end

