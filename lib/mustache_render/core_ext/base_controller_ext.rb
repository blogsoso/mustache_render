# -*- encoding : utf-8 -*-
module MustacheRender::CoreExt
  module BaseControllerExt
    def self.included(base)
      base.class_eval do
        helper_method :mustache_render

        extend   ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
#      def acts_as_mustache_renderer
#        helper_method :mustache_render
#        include InstanceMethods
#      end
    end

    module InstanceMethods
      def mustache_render(mustache_template='', mustache={})
        render :text => ::Mustache.render(mustache_template, mustache)
      end
    end
  end
end
