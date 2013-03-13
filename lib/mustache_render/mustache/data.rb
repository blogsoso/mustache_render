# -*- encoding : utf-8 -*-
module MustacheRender
  class Mustache::Data < ::Hash
    def initialize(options={})
      self.merge! options
    end

    [:render, :file_render, :impl_render].each do |method_name|
      define_method method_name do |path_or_template|
        ::MustacheRender::Mustache.send method_name, path_or_template, self
      end
    end

    def []=(name, value)
      super(name.to_sym, value)
    end

    def to_ary
    end

    def [](name)
      super(name.to_sym)
    end

    def deep_merge(other_hash)
      self.deep_dup.deep_merge!(other_hash)
    end

    # 深层的合并
    def deep_merge!(other_hash)
      other_hash = self.class.new(other_hash) unless other_hash.is_a?(self.class)

      other_hash.each_pair do |k,v|
        tv = self[k]

        unless v.is_a?(self.class)
          v = self.class.new(v) if v.is_a?(Hash)
        end

        self[k] = tv.is_a?(self.class) && v.is_a?(self.class) ? tv.deep_merge(v) : v
      end

      self
    end

    def deep_dup
      impl_deep_dup self
    end

    def method_missing method_name, *args, &block
      # 如果方法是赋值, 则直接赋值
      if method_name.to_s.end_with?('=')
        self[method_name.to_s.chop!] = args.first
      else
        result = self[method_name.to_sym]

        if result.is_a?(Hash) && !(result.is_a?(self.class))
          self[method_name] = self.class.new(result)
        elsif result.nil?
          self[method_name] = self.class.new
        else
          result
        end
      end
    end

    def stringify_keys!
      impl_stringify_keys! self
    end

    def symbolize_keys!
      impl_symbolize_keys! self
    end

    #
    # origin_hash_symbolize
    # origin_hash_stringify
    # origin_hash_symbolize! key全是 symbol的
    # origin_hash_stringify! key全市 string 的
    #
    [:symbolize, :stringify].each do |method_name|
      define_method "origin_hash_#{method_name}".to_sym do
        self.deep_dup.send "origin_hash_#{method_name}!".to_sym
      end

      define_method "origin_hash_#{method_name}!".to_sym do
        self.send "impl_origin_hash_#{method_name}".to_sym, self
      end
    end

    #
    # deep_stringify_keys
    # deep_stringify_keys!
    #
    [:stringify, :symbolize].each do |method_name|
      method_name_impl     = "impl_#{method_name}_keys".to_sym
      method_name_new_soft = "deep_#{method_name}_keys".to_sym
      method_name_new      = "deep_#{method_name}_keys!".to_sym

      define_method method_name_new_soft do
        self.deep_dup.send method_name_new
      end

      define_method method_name_new do
        tmp = self.send method_name_impl, self

        tmp.keys.each do |key|
          tmp[key] = self.send method_name_impl, tmp[key]
        end

        tmp
      end
    end

    private

    def impl_deep_dup v
      if v.is_a?(::Hash)
        tv = v.dup

        v.each do |key, value|
          tv[key] = impl_deep_dup value
        end

        tv
      elsif v.is_a?(::Array)
        v.map do |_v|
          impl_deep_dup _v
        end
      else
        v
      end
    end

    [:stringify, :symbolize].each do |method_name|
      typify_method = {:symbolize => :to_sym, :stringify => :to_s}[method_name]
      method_name_new = "impl_origin_hash_#{method_name}".to_sym
      define_method method_name_new do |v|
        if v.is_a?(::Hash)
          tv = Hash.new

          v.keys.each do |key|
            tv[key.send(typify_method)] = self.send(method_name_new, v[key])
          end

          tv
        elsif v.is_a?(::Array)
          v.map do |_v|
            self.send(method_name_new, _v)
          end
        else
          v
        end
      end
    end

    [:stringify, :symbolize].each do |method_name|
      typify_clazz = {:stringify => ::String, :symbolize => ::Hash}[method_name]
      method_name_new = "impl_#{method_name}_keys".to_sym
      typify_method = {:symbolize => :to_sym, :stringify => :to_s}[method_name]

      define_method method_name_new do |v|
        if v.is_a?(Hash)
          v.keys.each do |key|
            kv = v.delete key

            unless key.is_a?(typify_clazz)
              if(kv.is_a?(::Hash) && !(kv.is_a?(self.class)))
                kv = self.class.new(kv)
              end
            end

            v[key.send(typify_method)] = self.send method_name_new, kv
          end
        elsif v.is_a?(Array)
          v = v.map do |_v|
            self.send method_name_new, _v
          end
        end

        v
      end
    end

  end
end

