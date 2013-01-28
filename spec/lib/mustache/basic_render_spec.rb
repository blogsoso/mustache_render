# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'MustacheRender Render Basic Render' do
  context 'basic render' do
    before :each do

    end

    it 'basic render' do
      viewer = ::MustacheRender::Mustache.new

      viewer[:name] = 'Happy Wang'
      viewer.template = '{{name}}'
      viewer.render.should == 'Happy Wang'
      viewer.file_render('basic/8').should == "in-8file:Happy Wang\n"
    end
  end
end

