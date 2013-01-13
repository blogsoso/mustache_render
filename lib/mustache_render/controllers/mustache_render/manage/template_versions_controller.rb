# -*- encoding : utf-8 -*-
module MustacheRender::Manage
  class TemplateVersionsController < BaseController
    before_filter :load_template_record

    def show
      @mustache_render_template_version = MustacheRenderTemplateVersion.find params[:id]
    end

    def index
      @mustache_render_template_versions = @mustache_render_template.template_versions
    end

    def destroy
      # TODO: 是否增加删除功能
      @mustache_render_template_version = MustacheRenderTemplateVersion.find params[:id]

      @mustache_render_template_version.destroy

      redirect_to params[:return_to] || mustache_render_manage_folder_template_template_versions_url(
        :folder_id   => @mustache_render_template_version.folder_id,
        :template_id => @mustache_render_template_version.template_id
      )
    end

    protected

    def load_template_record
      @mustache_render_template = MustacheRenderTemplate.find params[:template_id]
      @mustache_render_folder   = @mustache_render_template.folder
    end

  end
end
