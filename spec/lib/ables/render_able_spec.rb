# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ::MustacheRender::RenderAble do

  context '测试基本情况' do
    module ShopDataPopulator
      module InstanceMethods

        private

        def impl_to_mustache result, options={}, &block
        end
      end
    end

    class ShopData
      include ::MustacheRender::RenderAble

      attr_reader :name, :age, :address

      def initialize param={}
        @name    = param[:name]
        @age     = param[:age]
        @address = param[:address]
      end

      self.load_musatche_populator ShopDataPopulator
    end

    it 'to_mustache Test' do
      a = ShopData.new
      a.mustache_populator.to_mustache.should == {:miss? => false}
      a.mustache_populator.to_mustache[:miss?].should == false
      a.mustache_populator.to_mustache do |result|
        result.merge!(:name => 'happy_2')
      end.should == {:miss? => false, :name => 'happy_2'}

      a.mustache_populator.to_mustache.render('{{miss?}}').should == 'false'

      a.mustache_populator.to_mustache do |result|
        result.merge!(:name => 'happy jinzhong', :age => 28)
      end.render('name:{{name}}  age:{{age}}').should == 'name:happy jinzhong  age:28'

    end

    it 'nil to_mustache' do
      nil.to_mustache[:miss?].should == true
    end
  end
end

