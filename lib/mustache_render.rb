# -*- encoding : utf-8 -*-
require 'mustache_render/adapter'
require 'mustache_render/config'
require 'mustache_render/mustache'
# require 'benchmark'

module MustacheRender
  def self.logger
    MustacheRender.config.logger
  end

  autoload :Adapter,       'mustache_render/adapter'
  autoload :PopulatorBase, 'mustache_render/populator_base'

  module CoreExt
    autoload :BaseControllerExt,   'mustache_render/core_ext/base_controller_ext'
  end
end

if defined?(::ActionController::Base)
  ::ActionController::Base.send :include, ::MustacheRender::CoreExt::BaseControllerExt
end

