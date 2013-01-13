# -*- encoding : utf-8 -*-
module MustacheRender::Models
  module MustacheRenderManagerMixin
    def self.included(base)
      base.class_eval do
        table_name = 'mustache_render_managers'
        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      # TODO: authenticate
      def authenticate?(user)
        true
      end
    end

    module InstanceMethods
      
    end
  end
end
