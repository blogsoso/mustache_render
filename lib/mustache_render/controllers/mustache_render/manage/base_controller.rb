# -*- encoding : utf-8 -*-
module MustacheRender::Manage
  class BaseController < ::ApplicationController
    helper BaseHelper

    before_filter :require_user_is_manager!
    before_filter :set_mustache_manage_view_path

    layout 'mustache_render/manage/base'

    protected

    #
    # 设置mustache的管理器的view path
    #
    def set_mustache_manage_view_path
      prepend_view_path "#{::MustacheRender.config.lib_base_path}/views"
    end

    def require_user_is_manager!
      if ::MustacheRender.config.manage_center_need_login?
        if !(defined?(current_user)) || current_user.nil?
          ## 当前用户没有登录，跳往的url
          redirect_to ::MustacheRender.config.user_login_url           ## 用户登录的url
        elsif !(::MustacheRenderManager.authenticate?(current_user))
          redirect_to ::MustacheRender.config.manager_authenticate_fail_url       ## 用户没有权限要跳转的url
        end
      end
    end
  end
end
