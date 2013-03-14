# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ::MustacheRender::RenderAble do

  context '测试基本情况' do
    module DefaultShopDataPopulator
      def impl_to_mustache result, filter_util, options, &block
        if filter_util.hit?("current_name")
          result[:current_name] = 'ShopDataPopulator'
        end

        deals_filter_util = filter_util.load("deals")

        if deals_filter_util.present?
          result[:deals] = {}

          if deals_filter_util.hit?("name")
            result[:deals][:name] = self.name
          end

          if deals_filter_util.hit?("title")
            result[:deals][:title] = self.title
          end

          if deals_filter_util.at('address') == :detail
            result[:deals][:address] = "detail:#{self.address}"
          end
        end

      end
    end

    class ShopData
      include ::MustacheRender::RenderAble::ForRecord

      attr_reader :name, :age, :address, :title

      def initialize param={}
        @name    = param[:name]
        @age     = param[:age]
        @title   = param[:title]
        @address = param[:address]
      end

      self.load_mustache_populator(
        DefaultShopDataPopulator
      ) do |config|
        config.filters_util = {
          :default => {
            :deals => {
              :name => false,
              :title => true,
              :address => true
            },
            :current_name => false
          },
          :array => {
            :deals => {
              :title => false,
              :address => :detail
            }
          }
        }
      end
    end

    it 'mustache_render Test' do
      start = Time.now

      a1 = ShopData.new
      a2 = ShopData.new :name => 'a2', :address => 'address2'
      a3 = ShopData.new :name => 'a3'
      a4 = ShopData.new :name => 'a4'
      a5 = ShopData.new :name => 'a5'
      a6 = ShopData.new :name => 'a6'
      a7 = ShopData.new :name => 'a7'

      a = [a1, a2, a3, nil]

      num = 1000

      (1..num).each do |i|
        a.mustache_render("", :filter => :array).should == ""

        a.mustache_render(
          "{{#any?}}any-true{{/any?}}{{#list}}{{#deals}}-address:{{address}}{{/deals}}{{/list}}",
            :filter => :array
        ).should == "any-true-address:detail:-address:detail:address2-address:detail:"

        a.mustache_file_render(
          "/mustache_render_ables/1",
            :filter => :array
        ).should == "<ul>\n  <li>name: </li>\n  <li>age: </li>\n  <li>address: detail:</li>\n</ul>\n<ul>\n  <li>name: </li>\n  <li>age: </li>\n  <li>address: detail:address2</li>\n</ul>\n<ul>\n  <li>name: </li>\n  <li>age: </li>\n  <li>address: detail:</li>\n</ul>\n"


        # a.to_mustache(:filter => :array).should == {
        #   :any? => true, :list => [
        #     {:nil? => false, :deals => {:address => "detail:"}},
        #     {:nil? => false, :deals => {:address => "detail:address2"}},
        #     {:nil? => false, :deals => {:address => "detail:"}},
        #     {:nil? => true}
        #   ], :pagination => {
        #     :support? => false
        #   }
        # }
      end

      time = Time.now - start
      puts "#{num}次执行时间mustache_render:#{time}"
    end

    it 'array to_mustache Test' do
      start = Time.now

      a1 = ShopData.new
      a2 = ShopData.new :name => 'a2', :address => 'address2'
      a3 = ShopData.new :name => 'a3'
      a4 = ShopData.new :name => 'a4'
      a5 = ShopData.new :name => 'a5'
      a6 = ShopData.new :name => 'a6'
      a7 = ShopData.new :name => 'a7'

      a = [a1, a2, a3, nil]

      num = 10000

      (1..num).each do |i|
        a.to_mustache(:filter => :array).should == {
          :any? => true, :list => [
            {:nil? => false, :deals => {:address => "detail:"}},
            {:nil? => false, :deals => {:address => "detail:address2"}},
            {:nil? => false, :deals => {:address => "detail:"}},
            {:nil? => true}
          ], :pagination => {
            :support? => false
          }
        }
      end

      time = Time.now - start
      puts "#{num}次执行时间array to_mustache:#{time}"
      time.should < 1
    end

    it 'class methods Test' do
      ShopData.mustache_populator_config.is_a?(MustacheRender::RenderAble::MustachePopulatorConfig).should be_true

      start = Time.now

      (1..10000).each do |i|
        a = ShopData.new :title => 'title_abc'

        a.to_mustache.should == {
          :deals => {
            :title => "title_abc"
          },
          :nil? => false
        }

        a = ShopData.new(
          :title => :title_bcd,
          :name  => :name_bcd
        )

        a.to_mustache.should == {
          :deals => {
            :title => :title_bcd
          },
          :nil? => false
        }

      end

      (Time.now - start).should < 0.5
    end

    it 'nil to_mustache' do
      nil.to_mustache[:nil?].should == true
    end
  end
end

