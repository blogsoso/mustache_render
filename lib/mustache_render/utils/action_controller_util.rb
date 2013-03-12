# -*- encoding : utf-8 -*-
module MustacheRender
  # include ::MustacheRender::ActionControllerUtil
  module ActionControllerUtil
    def self.included base
      base.class_eval do
        extend   ClassMethods
        include InstanceMethods
      end
    end

    module SharedMethods
      # 是否是mustache_render调试模式
      def mustache_render_at_debug_mode?
        return @_mustache_render_at_debug_mode if defined?(@_mustache_render_at_debug_mode)

        @_mustache_render_at_debug_mode = Rails.env.development? && params[:mustache_render_debug]
      end

      #
      # 定义了三个方法：
      #   render template, data
      #   file_render template_path, data
      #
      [:render, :file_render, :impl_render].each do |method_name|
        define_method "mustache_#{method_name}".to_sym do |path_or_template, data|
          impl_mustache_result_render method_name, path_or_template, data
        end
      end
    end

    module ClassMethods
    end

    module HelperMethods
      include SharedMethods

      private

      def impl_mustache_result_render(method_name, path_or_template='', data={})
        if mustache_render_at_debug_mode?
          ::MustacheRender.logger.debug <<-DEBUG_TEXT
>>> impl_mustache_result_render##{method_name} path_or_template: #{path_or_template}
>>> data: #{data.inspect}
DEBUG_TEXT
        end

        raw(::MustacheRender::Mustache.send method_name, path_or_template, data)
      end
    end

    module InstanceMethods
      include SharedMethods

      private

      def impl_mustache_result_render(method_name, path_or_template='', data={})
        if mustache_render_at_debug_mode?
          render :json => data
        else
          render :text => (::MustacheRender::Mustache.send method_name, path_or_template, data)
        end
      end
    end
  end
end
