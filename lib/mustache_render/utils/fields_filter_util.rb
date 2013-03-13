# -*- encoding : utf-8 -*-
module MustacheRender
  class FieldsFilterUtil
    RULE_JOIN_GAP = '#'

    attr_reader :rules, :rules_tree

    # data = {
    #   :deals => [
    #      {
    #        :name  => 'name_1',
    #        :title => 'title_1',
    #        :price => 23.4,
    #        :shops => [
    #           {
    #             :name => 'shop_1',
    #             :address => 'address 1'
    #           }
    #        ]
    #      }
    #   ],
    #   :shop => {
    #     :name => 1,
    #     :deals => [
    #       {
    #          :name => "deal_1"
    #       }
    #     ]
    #   },
    #   :deal => {
    #     :name => ''
    #   }
    # }
    #
    # ########
    # filter = {
    #   :default => {
    #     :deals => {
    #       :name => true
    #     }
    #   }
    # }
    #
    # 转译配置语言
    def initialize rule={}
      @rules = {}
      @rules_tree = {}

      @empty = (
        rule.is_a?(Hash) || rule.is_a?(Array)
      ) ? rule.empty? : true

      parse_rules :rule => rule

      @rules.freeze
      @rules_tree.freeze

      self
    end

    def empty?
      @empty
    end

    def present?
      !(empty?)
    end

    def load formater=nil
      if @rules_tree.key?(str = generate_string_formater(formater))
        @rules_tree[str]
      else
        self.class.new
      end
    end

    def match?(formater=nil)
      present? && !!at(formater)
    end

    alias :hit? :match?

    def at(formater=nil)
      @rules[generate_string_formater(formater)]
    end

    private

    def generate_string_formater formater
       if formater.is_a?(Array)
        formater.join(RULE_JOIN_GAP)
      else
        "#{formater}"
      end
    end

    def parse_rules options={}
      path = "#{options[:path]}"
      rule = options[:rule]
      path_empty = path.strip.size == 0

      case rule
      when Hash
        rule.each do |key, val|
          _path = path_empty ? "#{key}" : "#{path}#{RULE_JOIN_GAP}#{key}"
          @rules_tree[_path] = self.class.new(val)
          @rules[_path] = parse_rules :path => _path, :rule => val
          parse_rules :path => "#{_path}", :rule => val
        end
      when Array
        rule.each do |rul|
          parse_rules :path => "#{path}", :rule => rul
        end
      when NilClass
        unless path_empty
          @rules[path] = nil
          @rules_tree[path] = nil
        end
      else
        unless path_empty
          @rules[path] = rule
          @rules_tree[path] = rule
        end
      end
    end
  end
end
