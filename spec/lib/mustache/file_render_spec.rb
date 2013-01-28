# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'MustacheRender::Mustache.xxx_render' do
  before :each do
  end

  it 'template scan_tags test' do
    result = MustacheRender::Mustache.file_render 'scan_tags/1', {}

  end

  it 'template file 5.mustache render ok' do
    result = MustacheRender::Mustache.file_render 'basic/5', {}
    result.should == <<-TEXT
file:5, in-file6

file:5-2, in-file6

file:5-3, in-file6

file:5-4, in-file6

file:5-5, in-file6

file:5-6, in-file6

file:5-7, in-file6

file:5-8, in-file6

file:5-9, in-file6

file:5-10, in-file6

file:5-11, in-file6

TEXT
  end

  it 'template file 1.mustache render ok' do
    result = MustacheRender::Mustache.file_render 'basic/1', {:filename => '1.mustache'}
    result.should == <<-TEXT
Hello!1.mustache
TEXT
  end

  it 'template 2 with partial 1 render OK' do
     result = MustacheRender::Mustache.file_render 'basic/2', {:filename => 'in1'}
     result.should == <<-TEXT
file-2Hello!in1

TEXT
  end

  it 'template file 3.mustache partial with 2 render OK' do
     result = MustacheRender::Mustache.file_render 'basic/3', {:filename => 'in1'}
     result.should == <<-TEXT
file3file-2Hello!in1


TEXT

  end
end
