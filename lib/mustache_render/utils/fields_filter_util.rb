# -*- encoding : utf-8 -*-
module MustacheRender
  class FieldsFilterUtil < ::MustacheRender::Mustache::Data
    def filter?(field, wil=nil)
      _val = self[field]

      if _val
        case _val
        when Symbol
          _val == :all
        when Array
          wil.nil? || _val.include?(wil)
        else
          false
        end
      else
        false
      end
    end

    def load_config filter=:default
      (
        self[filter || :default] || self[:default]
      ) || self.class.new
    end
  end
end
