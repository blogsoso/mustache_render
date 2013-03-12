# -*- encoding : utf-8 -*-
module MustacheRender
  autoload :ActionControllerUtil, "#{File.dirname(__FILE__)}/utils/action_controller_util"
  autoload :FieldsFilterUtil,     "#{File.dirname(__FILE__)}/utils/fields_filter_util"
  autoload :ArrayUtil,            "#{File.dirname(__FILE__)}/utils/array_util"
end

if defined?(::ActionController::Base)
  ::ActionController::Base.send :include, ::MustacheRender::ActionControllerUtil
end

