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
      def authenticate?(user)
        user.id == 1
      end
    end

    module InstanceMethods
      
    end
  end
end
