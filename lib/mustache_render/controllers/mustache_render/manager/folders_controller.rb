module MustacheRender::Manager
  class FoldersController < BaseController
    def index

    end

    def show
      @mustache_render_folder = MustacheRenderFolder.find params[:id]
      @mustache_render_templates = @mustache_render_folder.templates
    end

    def new
      @mustache_render_folder = MustacheRenderFolder.new(:parent_id => params[:parent_id])

    end

    def edit
      @mustache_render_folder = MustacheRenderFolder.find params[:id]

    end

    def create
      @mustache_render_folder = MustacheRenderFolder.new(params[:folder])

      if @mustache_render_folder.save
        redirect_to mustache_render_manager_folder_url(@mustache_render_folder)
      else
        render :new
      end
    end

    def update
      @mustache_render_folder = MustacheRenderFolder.find params[:id]

      if @mustache_render_folder.update_attributes(params[:folder])
        redirect_to mustache_render_manager_folder_url(@mustache_render_folder)
      else
        render :edit
      end
    end

    def destroy
      # TODO: 是否增加删除功能
    end
  end
end
