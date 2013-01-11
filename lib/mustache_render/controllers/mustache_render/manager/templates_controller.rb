# -*- encoding : utf-8 -*-
module MustacheRender::Manager
  class TemplatesController < BaseController
    before_filter :load_folder_record

    def show
      @mustache_render_template = MustacheRenderTemplate.find params[:id]
    end

    def new
      @mustache_render_template = MustacheRenderTemplate.new(:folder_id => params[:folder_id])

    end

    def edit
      @mustache_render_template = MustacheRenderTemplate.find params[:id]

    end

    def create
      @mustache_render_template = MustacheRenderTemplate.new(params[:mustache_render_template])

      if @mustache_render_template.save
        redirect_to mustache_render_manager_folder_template_url(
          :folder_id => @mustache_render_template.folder_id, :id => @mustache_render_template
        )
      else
        render :new
      end
    end

    def update
      @mustache_render_template = MustacheRenderTemplate.find params[:id]

      if @mustache_render_template.update_attributes(params[:mustache_render_template])
        redirect_to mustache_render_manager_folder_template_url(
          :folder_id => @mustache_render_template.folder_id, :id => @mustache_render_template
        )
      else
        render :edit
      end
    end

    def destroy
      # TODO: 是否增加删除功能
    end

    protected

    def load_folder_record
      @mustache_render_folder = MustacheRenderFolder.find params[:folder_id]
    end
  end
end
