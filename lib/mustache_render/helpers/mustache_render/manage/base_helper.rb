# -*- encoding : utf-8 -*-
module MustacheRender::Manage
  module BaseHelper
    # 输出基本的js代码
    def output_base_js_code
    #   if MustacheRender.adapter.rails_2?
    #     # rails 2 will render
    #     <<-HTML

    #     HTML
    #   else
    #     # rails_3 will render
    #     <<-HTML

    #     HTML
    #   end
    end

    # 输出jquery code
    def generate_jquery_code
      @@generated_jquery_code ||= File.read("#{::MustacheRender.config.lib_base_path}/resources/jquery.js")
      HTML
    end

    def generate_jquery_ujs_code
      @@generated_jquery_ujs_code ||= File.read("#{::MustacheRender.config.lib_base_path}/resources/jquery_ujs.js")
    end
  end
end

