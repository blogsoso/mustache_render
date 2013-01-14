require 'spec_helper'

describe 'MustacheRender::Mustache.db_render' do
  before :each do
    MustacheRender.configure do |config|
      config.file_template_root_path = ROOT_PATH + '/resources/templates'
    end
  end

  it 'compile' do
    _p = MustacheRender::Mustache::Parser.new.compile('{{>name}}')
    _p.should == ''
  end

  it 'template file 1.mustache render ok' do
    result = MustacheRender::Mustache.file_render '1', {:filename => '1.mustache'}
    result.should == <<-TEXT
Hello!1.mustache
TEXT
  end

  it 'template 2 with partial 1 render OK' do
     result = MustacheRender::Mustache.file_render '2', {:filename => 'in1'}
     result.should == <<-TEXT
file-2Hello!in1

TEXT
  end

  it 'template file 3.mustache partial with 2 render OK' do
     result = MustacheRender::Mustache.file_render '3', {:filename => 'in1'}
     result.should == <<-TEXT
file3file-2Hello!in1


TEXT

  end
end
