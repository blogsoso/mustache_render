# -*- encoding : utf-8 -*-
require 'mustache_render/adapter'
require 'mustache_render/config'
require 'mustache_render/mustache'

module MustacheRender
<<<<<<< HEAD
=======
  def self.logger
    MustacheRender.config.logger
  end

>>>>>>> 470b53b7c4b5e433b72058d09dcf680f63b76f80
  autoload :Adapter, 'mustache_render/adapter'

  module Manage
    autoload :BaseHelper,          'mustache_render/helpers/mustache_render/manage/base_helper'

    autoload :BaseController,             'mustache_render/controllers/mustache_render/manage/base_controller'
    autoload :FoldersController,          'mustache_render/controllers/mustache_render/manage/folders_controller'
    autoload :TemplatesController,        'mustache_render/controllers/mustache_render/manage/templates_controller'
    autoload :TemplateVersionsController, 'mustache_render/controllers/mustache_render/manage/template_versions_controller'
  end

  module CoreExt
    autoload :BaseControllerExt,   'mustache_render/core_ext/base_controller_ext'
  end

  module Controllers
  end

  module Models
    autoload :MustacheRenderManagerMixin,           'mustache_render/models/mustache_render_manager_mixin'
    autoload :MustacheRenderFolderMixin,            'mustache_render/models/mustache_render_folder_mixin'
    autoload :MustacheRenderTemplateMixin,          'mustache_render/models/mustache_render_template_mixin'
    autoload :MustacheRenderTemplateVersionMixin,   'mustache_render/models/mustache_render_template_version_mixin'
  end
end

if defined?(::ActionController::Base)
  ::ActionController::Base.send :include, ::MustacheRender::CoreExt::BaseControllerExt
end

