# #
# # 注册action view handler
# #
# #
# module MustacheRender::CoreExt
#   module ActionViewHandler
#     def self.call template
#       if template.locals.include? :mustache
#         ::MustacheRender::Mustache.render(template.source.inspect, {}).html_safe
#       else
#         "#{template.source.inspect}".html_safe
#       end
#     end
# 
#   end
# end
# 
