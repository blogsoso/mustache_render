# -*- encoding : utf-8 -*-
module MustacheRenderFolderMixin
  def self.included(base)
    base.class_eval do
      table_name = 'mustache_render_folders'

      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods

  end

  module InstanceMethods
    
  end
end
