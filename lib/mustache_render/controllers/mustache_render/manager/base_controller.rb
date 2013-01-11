module MustacheRender::Manager
  class BaseController < ::ApplicationController
    before_filter :set_mustache_manager_view_path

    layout 'mustache_render/manager/base'

    protected

    #
    # 设置mustache的管理器的view path
    #
    def set_mustache_manager_view_path
      prepend_view_path "#{::MustacheRender.config.lib_base_path}/views"
    end
  end
end
