# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'MustacheRender Render Basic Render' do
  context 'basic render' do
    before :each do

    end

    it "class extend test" do
      class DealFormat < ::MustacheRender::Mustache
        def data
          'data1'
        end

        def render1
          "render2"
        end

        def hello
          {
            :name => 'happy',
            :age  => 28
          }
        end
      end

      DealFormat.render("{{data}}").should == 'data1'
      DealFormat.render("{{render1}}").should == 'render2'
      DealFormat.render("{{hello.name}}").should == 'happy'
    end

    it 'basic render' do
      viewer = ::MustacheRender::Mustache.new

      viewer[:name] = 'Happy Wang'
      viewer.template = '{{name}}'
      viewer.render.should == 'Happy Wang'
      expect {
        viewer.file_render('basic/8').should == "in-8file:Happy Wang\n"
      }.to raise_error(MustacheRender::MustacheTemplateMissError)
    end
  end
end

