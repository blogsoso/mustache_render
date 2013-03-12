# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'MustacheRender Mustache Data' do
  context 'basic test' do
    let :data do
      MustacheRender::Mustache::Data.new
    end

    before :each do

    end

    it 'render basic' do
      data[:a] = 'hello'
      data.b = 'happy'
      data.render('{{a}}{{b}}').should == 'hellohappy'
    end

    it 'render a array' do
      data.a = [{:a => 1, :b => 2}, {:a => 10, :b => 20}]
      data.render('{{#a}}a:{{a}} b:{{b}}{{/a}}').should == "a:1 b:2a:10 b:20"
    end

    it '所有的key转为symbol' do
      data[:a] = 'b'
      data.inspect.should == "{\:a=>\"b\"}"
    end

    it '当为数组的时候，每个元素也许要进行key字符串化' do
      data.b.c = [{:a => 'a', 'b' => 'b'}]
      data.should == {:b=>{:c=>[{:a=>"a", "b"=>"b"}]}}
    end

    it '基本赋值方法' do

      data.site = {
        :name => 'a'
      }

      data.inspect.should == "{:site=>{:name=>\"a\"}}"
      data.site.inspect.should == "{:name=>\"a\"}"
    end

    it '取值类型为数组' do
      data.sites = [1, 2, 3]

      data.sites.inspect.should == '[1, 2, 3]'
    end

    it '直接调用一个空方法' do
      data.helloworld_abcd.should == {}
      data.helloworld_abcd.class.should == ::MustacheRender::Mustache::Data
    end

    it '连续的调用一个方法' do
      data.a.b.c.should == {}

      data.a.b.c.sites = [1, 2, 3]
      data.a.b.c.sites.inspect.should == '[1, 2, 3]'
    end

    it 'hello? 这类方法的生成是否正常' do
      data.a['hello?'] = false
      data.a.hello?.should == false
    end
  end
end

