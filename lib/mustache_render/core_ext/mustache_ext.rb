# -*- encoding : utf-8 -*-
module MustacheRender
  module CoreExt
    #
    # mustache 类的扩展
    #
    module MustacheExt
      def self.included(base)
        base.class_eval do
          extend  ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
        # now happy code here
        #
        # 从数据库记录中的模板进行渲染
        #
        def render_db(path_name, context={})
          render(partial(path_name, :media => :db), context)
        end

        def partial(name, options={})
          if options[:media] == :file
            File.read("#{template_path}/#{name}.#{template_extension}")
          else
            db_template = ::MustacheRenderTemplate.find_by_full_path(name)
            db_template.try :content
          end
        end

        #### after here from origin #######################################

        # Instantiates an instance of this class and calls `render` with
        # the passed args.
        #
        # Returns a rendered String version of a template
        def render(*args)
          new.render(*args)
        end

        alias_method :to_html, :render
        alias_method :to_text, :render

        # Given a file name and an optional context, attempts to load and
        # render the file as a template.
        def render_file(name, context = {})
          render(partial(name), context)
        end

        ## # Given a name, attempts to read a file and return the contents as a
        ## # string. The file is not rendered, so it might contain
        ## # {{mustaches}}.
        ## #
        ## # Call `render` if you need to process it.
        ## def partial(name)
        ##   File.read("#{template_path}/#{name}.#{template_extension}")
        ## end

        #
        # Private API
        #

        # When given a symbol or string representing a class, will try to produce an
        # appropriate view class.
        # e.g.
        #   Mustache.view_namespace = Hurl::Views
        #   Mustache.view_class(:Partial) # => Hurl::Views::Partial
        def view_class(name)
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
        def const_get!(name)
          name.split('::').inject(Object) do |klass, name|
            klass.const_get(name)
          end
        rescue NameError
          nil
        end

        # Has this template already been compiled? Compilation is somewhat
        # expensive so it may be useful to check this before attempting it.
        def compiled?
          @template.is_a? Template
        end

        # template_partial => TemplatePartial
        # template/partial => Template::Partial
        def classify(underscored)
          underscored.split('/').map do |namespace|
            namespace.split(/[-_]/).map do |part|
              part[0] = part[0].chr.upcase; part
            end.join
          end.join('::')
        end

        #   TemplatePartial => template_partial
        # Template::Partial => template/partial
        # Takes a string but defaults to using the current class' name.
        def underscore(classified = name)
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
        def templateify(obj)
          if obj.is_a?(Template)
            obj
          else
            Template.new(obj.to_s)
          end
        end

        # Return the value of the configuration setting on the superclass, or return
        # the default.
        #
        # attr_name - Symbol name of the attribute.  It should match the instance variable.
        # default   - Default value to use if the superclass does not respond.
        #
        # Returns the inherited or default configuration setting.
        def inheritable_config_for(attr_name, default)
          superclass.respond_to?(attr_name) ? superclass.send(attr_name) : default
        end
      end

      ########## instance methods ################################################################

      module InstanceMethods

        #
        # Public API
        #

        # Parses our fancy pants template file and returns normal file with
        # all special {{tags}} and {{#sections}}replaced{{/sections}}.
        #
        # data - A String template or a Hash context. If a Hash is given,
        #        we'll try to figure out the template from the class.
        #  ctx - A Hash context if `data` is a String template.
        #
        # Examples
        #
        #   @view.render("Hi {{thing}}!", :thing => :world)
        #
        #   View.template = "Hi {{thing}}!"
        #   @view = View.new
        #   @view.render(:thing => :world)
        #
        # Returns a rendered String version of a template
        def render(data = template, ctx = {})
          if data.is_a? Hash
            ctx = data
            tpl = templateify(template)
          elsif data.is_a? Symbol
            self.template_name = data
            tpl = templateify(template)
          else
            tpl = templateify(data)
          end

          return tpl.render(context) if ctx == {}

          begin
            context.push(ctx)
            tpl.render(context)
          ensure
            context.pop
          end
        end

        alias_method :to_html, :render
        alias_method :to_text, :render

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
        def render_file(name, context = {})
          self.class.render_file(name, context)
        end

        # Override this in your subclass if you want to do fun things like
        # reading templates from a database. It will be rendered by the
        # context, so all you need to do is return a string.
        def partial(name)
          self.class.partial(name)
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


        # Has this instance or its class already compiled a template?
        def compiled?
          (@template && @template.is_a?(Template)) || self.class.compiled?
        end

        def templateify(obj)
          self.class.templateify(obj)
        end
      end
    end
  end
end
