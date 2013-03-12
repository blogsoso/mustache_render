# -*- encoding : utf-8 -*-
require "#{File.dirname(__FILE__)}/mustache/template"
require "#{File.dirname(__FILE__)}/mustache/context"
require "#{File.dirname(__FILE__)}/mustache/data"

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
      self.template = data

      return self.template.render(context) if ctx == {}

      begin
        context.push(ctx)
        self.template.render(context)
      ensure
        context.pop
      end
    end

    # Context accessors.
    #
    # view = Mustache.new
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

    # Given a file name and an optional context, attempts to load and
    # render the file as a template.
    def self.file_render(name, context = {})
      self.new.file_render name, context
    end

    # Given a file name and an optional context, attempts to load and
    # render the file as a template.
    def file_render(name, context = {})
      @media = :file
      render(partial(name), context)
    end

    def self.db_render(full_path, context={})
      self.new.db_render full_path, context
    end

    def db_render(full_path, context={})
      @media = :db
      render(partial(full_path), context)
    end

    def impl_read_db_template name
      db_template = ::MustacheRenderTemplate.find_with_full_path(name)
      db_template.try :content
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
          raise ::MustacheRender::MustacheTemplateMissError.new("miss read file template error: #{full_path}")
        else
          ''
        end
      end
    end

    def read_template_from_media name, media
      ::MustacheRender.logger.debug "MustacheRender render -> read template from #{media}: #{name}"
      case media
      when :file
        impl_read_file_template name
      end
    end

    # Override this in your subclass if you want to do fun things like
    # reading templates from a database. It will be rendered by the
    # context, so all you need to do is return a string.
    def partial(name)
      name = self.class.generate_template_name name, config.file_template_extension

      # return self.read_template_from_media name, media
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

    #
    # Private API
    #

    # When given a symbol or string representing a class, will try to produce an
    # appropriate view class.
    # e.g.
    #   Mustache.view_namespace = Hurl::Views
    #   Mustache.view_class(:Partial) # => Hurl::Views::Partial
    def self.view_class(name)
      if name != classify(name.to_s)
        name = classify(name.to_s)
      end

      # Emptiness begets emptiness.
      if name.to_s == ''
        return Mustache
      end

      file_name = underscore(name)

      name = "#{view_namespace}::#{name}"

      if const = const_get!(name)
        const
      elsif File.exists?(file = "#{view_path}/#{file_name}.rb")
        require "#{file}".chomp('.rb')
        const_get!(name) || Mustache
      else
        Mustache
      end
    end

    # Supercharged version of Module#const_get.
    #
    # Always searches under Object and can find constants by their full name,
    #   e.g. Mustache::Views::Index
    #
    # name - The full constant name to find.
    #
    # Returns the constant if found
    # Returns nil if nothing is found
    def self.const_get!(name)
      name.split('::').inject(Object) do |klass, name|
        klass.const_get(name)
      end
    rescue NameError
      nil
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

    #   TemplatePartial => template_partial
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
  end
end
