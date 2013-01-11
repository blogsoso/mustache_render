# -*- encoding : utf-8 -*-
module MustacheRender::CoreExt
  module BaseControllerExt
    def self.included(base)
      base.class_eval do
        helper_method :mustache_db_render

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
      # def mustache_render(mustache_template='', mustache={})
      #   render :text => ::Mustache.render(mustache_template, mustache)
      # end

      #
      # 使用数据库中的模板进行渲染
      # - template_path: 模板的路径
      #
      def mustache_db_render(template_path=nil, mustache={})
        result = ::Mustache.render_db(template_path, mustache)
        if self.is_a?(ActionController::Base)
          render :text => result
        else
          result
        end
      end
    end
  end
end
