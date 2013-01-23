# -*- encoding : utf-8 -*-
module MustacheRender::CoreExt
  module BaseControllerExt
    def self.included(base)
      base.class_eval do
        helper HelperMethods

        extend   ClassMethods
        include InstanceMethods
      end
    end

    module SharedMethods
      def mustache_render template='', mustache={}
        result = ::MustacheRender::Mustache.render(template, mustache)
        impl_mustache_result_render result
      end

      def mustache_file_render template_path=nil, mustache={}
        result = ::MustacheRender::Mustache.file_render(template_path, mustache)
        impl_mustache_result_render result
      end

      #
      # 使用数据库中的模板进行渲染
      # - template_path: 模板的路径
      #
      def mustache_db_render(template_path=nil, mustache={})
        result = ::MustacheRender::Mustache.db_render(template_path, mustache)
        impl_mustache_result_render result
      end
    end

    module ClassMethods
    end

    module HelperMethods
      include SharedMethods

      private

      def impl_mustache_result_render(result)
        raw result
      end
    end

    module InstanceMethods
      include SharedMethods

      private

      def impl_mustache_result_render(result)
        render :text => result
      end
    end
  end
end
