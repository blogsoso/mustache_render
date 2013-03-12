# -*- encoding : utf-8 -*-
require "#{File.dirname(__FILE__)}/mustache_render/errors"
require "#{File.dirname(__FILE__)}/mustache_render/config"
require "#{File.dirname(__FILE__)}/mustache_render/mustache"
require "#{File.dirname(__FILE__)}/mustache_render/utils"
require "#{File.dirname(__FILE__)}/mustache_render/ables"

module MustacheRender
  def self.logger
    MustacheRender.config.logger
  end
end


