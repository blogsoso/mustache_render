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
          }
        }
      end
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
      end

      (Time.now - start).should < 0.5
    end

    it 'nil to_mustache' do
      nil.to_mustache[:nil?].should == true
    end
  end
end

