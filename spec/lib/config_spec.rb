# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'MustacheRender config' do
  context 'config' do
    before :each do

    end

    it 'config not nil' do
      ::MustacheRender.config.nil?.should == false
    end
  end
end
