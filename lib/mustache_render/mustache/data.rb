# -*- encoding : utf-8 -*-
module MustacheRender
  class Mustache
    # 将所有的key转为字符串
    class Data < ::Hash
      def initialize options = {}
        self.merge! options
      end

      [:render, :file_render, :impl_render].each do |method_name|
        define_method method_name do |path_or_template|
          ::MustacheRender::Mustache.send method_name, path_or_template, self
        end
      end

      def []=(name, value)
        result = super(name.to_s, value)
        self.each_pair do |k, v|
          impl_stringify_keys v
        end
        # self.stringify_keys!
        result
      end

      def [](name)
        super(name.to_s)
      end

      # 深层复制
      def deep_dup
        duplicate = self.dup
        duplicate.each_pair do |k, v|
          tv = duplicate[k]
          duplicate[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_dup : v
        end
        duplicate
      end

      #
      # data = MustacheRender::Mustache::Data.new
      # data.site = {
      #   :name => 'abc'
      # }
      #
      # 等价于
      #
      # data['site'] = {
      #   :name => 'abc'
      # }
      #
      def method_missing method_name, *args, &block
        # 如果方法是赋值, 则直接赋值
        if method_name.to_s[-1,1] == "="
          self[method_name.to_s.chop!] = args.first
        else
          result = self[method_name.to_s]

          if result.is_a?(Hash)
            self[method_name.to_s] = Data.new(result)
          elsif result.nil? # 如果为空的话，则生成一个新的对象
            self[method_name.to_s] = Data.new {}
          else
            result
          end
        end
      end

      def stringify_keys!
        raise 'not impl'
      end

      def symbolize_keys!
        raise 'not impl'
      end

      private

      def impl_stringify_keys(v)
        if v.is_a?(::Hash)
          v.keys.each do |key|
            v[key.to_s] = v.delete(key) unless key.is_a?(::String)
          end
        elsif v.is_a?(::Array)
          v.each do |_v|
            impl_stringify_keys _v
          end
        end
      end

    end
  end
end

