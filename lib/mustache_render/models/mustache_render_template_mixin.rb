# -*- encoding : utf-8 -*-
module MustacheRenderTemplateMixin
  def self.included(base)
    base.class_eval do
      table_name = 'mustache_render_templates'

      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods

  end

  module InstanceMethods
    
  end
end

