# -*- encoding : utf-8 -*-
require 'mustache_render/mustache/template'
require 'mustache_render/mustache/context'
require 'mustache_render/mustache/data'

module MustacheRender
  class Mustache
    def self.render(*args)
      new.render(*args)
    end

    attr_reader :media ## 模板的媒介

    def config
      ::MustacheRender.config
    end

    def media
      @media ||= config.default_render_media
    end

    def render(data = template, ctx = {})
      impl_logger :level => :debug, :operation => 'MustacheRender::Mustache.render' do
        impl_template_render data, ctx
      end
    end

    # TODO: 语法检查,片段树
    def partials_tree

    end

    # Context accessors.
    #
    # view = ::MustacheRender::Mustache.new
    # view[:name] = "Jon"
    # view.template = "Hi, {{name}}!"
    # view.render # => "Hi, Jon!"
    def [](key)
      context[key.to_sym]
    end

    def []=(key, value)
      context[key.to_sym] = value
    end

    # A helper method which gives access to the context at a given time.
    # Kind of a hack for now, but useful when you're in an iterating section
    # and want access to the hash currently being iterated over.
    def context
      @context ||= Context.new(self)
    end

    # 使用default_media 进行渲染
    def self.impl_render(name, context={})
      self.new.send :impl_render, name, context
    end

    def impl_render name, context={}
      send "#{::MustacheRender.config.default_render_media}_render".to_sym, name, context
    end

    # Given a file name and an optional context, attempts to load and
    # render the file as a template.
    def self.file_render(name, context = {})
      self.new.file_render name, context
    end

    # Given a file name and an optional context, attempts to load and
    # render the file as a template.
    def file_render(name, context = {})
      impl_logger :level => :debug, :operation => "#{self.class}.file_render" do
        @media = :file
        render(partial(name), context)
      end
    end

    def self.generate_template_name(name, template_extension)
      # 如果路径中以扩展名结尾，则直接去取这个文件
      name = name.to_s.strip

      if name.start_with?('/')
        name = name[1..-1]
      end

      if name.end_with?(template_extension)
        "#{name}"
      else
        "#{name}#{template_extension}"
      end
    end

    def impl_read_file_template name
      # TODO: 对路径的语法需要加强
      full_path = "#{config.file_template_root_path}/#{name}"

      begin
        File.read full_path
      rescue
        if config.raise_on_file_template_miss?
          raise ::MustacheRender::Mustache::TemplateMiss.new("read file template error: #{full_path}")
        else
          ''
        end
      end
    end

    def read_template_from_media name, media
      # ::MustacheRender.logger.debug "MustacheRender render -> read template from #{media}: #{name}"

      impl_logger :level => :debug,
        :operation => "MustacheRender render -> read template from #{media}: #{name}" do

        case media
        when :file
          # if ::MustacheRender.config.file_template_cache?
          #   self.class.fetch_partial_cache name, media, :expires_in => ::MustacheRender.config.file_template_cache_expires_in do
          #     impl_read_file_template name
          #   end
          # else
          #   impl_read_file_template name
          # end

          impl_read_file_template name
        end
      end
    end

    # Override this in your subclass if you want to do fun things like
    # reading templates from a database. It will be rendered by the
    # context, so all you need to do is return a string.
    def partial(name)
      name = self.class.generate_template_name name, config.file_template_extension

      @_cached_partials ||= {}
      (@_cached_partials[media] ||= {})[name] ||= self.read_template_from_media name, media
    end

    # Override this to provide custom escaping.
    #
    # class PersonView < Mustache
    #   def escapeHTML(str)
    #     my_html_escape_method(str)
    #   end
    # end
    #
    # Returns a String
    def escapeHTML(str)
      CGI.escapeHTML(str)
    end

    # Has this template already been compiled? Compilation is somewhat
    # expensive so it may be useful to check this before attempting it.
    def self.compiled?
      @template.is_a? Template
    end

    # Has this instance or its class already compiled a template?
    def compiled?
      (@template && @template.is_a?(Template)) || self.class.compiled?
    end

    def template
      return @template if @template

      self.template = ''
    end

    def template= template
      @template = templateify(template)
    end

    # template_partial => TemplatePartial
    # template/partial => Template::Partial
    def self.classify(underscored)
      underscored.split('/').map do |namespace|
        namespace.split(/[-_]/).map do |part|
          part[0] = part[0].chr.upcase; part
        end.join
      end.join('::')
    end

    # TemplatePartial => template_partial
    # Template::Partial => template/partial
    # Takes a string but defaults to using the current class' name.
    def self.underscore(classified = name)
      classified = name if classified.to_s.empty?
      classified = superclass.name if classified.to_s.empty?

      string = classified.dup.split("#{view_namespace}::").last

      string.split('::').map do |part|
        part[0] = part[0].chr.downcase
        part.gsub(/[A-Z]/) { |s| "_#{s.downcase}"}
      end.join('/')
    end

    # Turns a string into a Mustache::Template. If passed a Template,
    # returns it.
    def self.templateify(obj)
      if obj.is_a?(Template)
        obj
      else
        Template.new(obj.to_s)
      end
    end

    def templateify(obj)
      self.class.templateify(obj)
    end

    # Return the value of the configuration setting on the superclass, or return
    # the default.
    #
    # attr_name - Symbol name of the attribute.  It should match the instance variable.
    # default   - Default value to use if the superclass does not respond.
    #
    # Returns the inherited or default configuration setting.
    def self.inheritable_config_for(attr_name, default)
      superclass.respond_to?(attr_name) ? superclass.send(attr_name) : default
    end

    private

    def impl_logger options={}
      level = options[:level] || :debug

      result = nil

      if block_given?
        start_at = Time.now
        result = yield
        ms = ((Time.now - start_at) * 1000).to_i
        MustacheRender.logger.send level, impl_format_log_entry(
          "#{options[:operation]} (#{ms}ms)", options[:message]
        )
      end

      result
    end

    def impl_format_log_entry(operation, message = nil)
      "  \033[4;34;1m#{operation}\033[0m   \033[0;1m#{message}\033[0m"
    end

    def impl_template_render(data=template, ctx={})
      self.template = data

      return self.template.render(context) if ctx == {}

      begin
        context.push(ctx)
        self.template.render(context)
      ensure
        context.pop
      end
    end

  end
end
