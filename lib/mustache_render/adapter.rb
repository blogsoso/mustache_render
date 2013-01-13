# -*- encoding : utf-8 -*-
module MustacheRender
  #
  # MustacheRender的适配器
  #
  class << self
    def adapter
      @adapter ||= Adapter.new
    end

    def adapter_configure
      yield(@adapter ||= Adapter.new)
    end
  end

  class Adapter
    def initialize
    end

    ############# routes ##########################################
    def manage_route_adapter(router)
      if rails_2?
        router.namespace :mustache_render do |render|
          render.namespace :manage do |manage|
            manage.resources :folders do |folder|
              folder.resources :templates, :only => [:show, :new, :edit, :update, :create, :destroy] do |template|
                template.resources :template_versions, :only => [:show, :index, :destroy, :update, :edit], :member => {
                  :revert => :post
                }
              end
            end
          end
        end
      elsif rails_3?
        router.namespace :mustache_render do
          router.namespace :manage do
            router.resources :folders do
              router.resources :templates, :only => [:show, :new, :edit, :update, :create, :destroy] do |template|
                router.resources :template_versions, :only => [:show, :index, :destroy, :update, :edit] do
                  router.member do
                    router.post :revert
                  end
                end
              end
            end
          end
        end
      end
    end

    ################## after about rails ##########################
    def rails?
      defined?(Rails)
    end

    def rails_version
      return @rails_version if defined?(@rails_version)

      @rails_version = if rails?
                         Rails.version
                       end
    end

    def rails_3?
      return @rails_3 if defined?(@rails_3)

      @rails_3 = (rails? && rails_version > '3.0.0')
    end

    def rails_2?
      return @rails_2 if defined?(@rails_2)
      @rails_2 = (rails? && rails_version > '2.0.0' && rails_version < '3.0.0')
    end
  end
end
