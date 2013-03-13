# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ::MustacheRender::FieldsFilterUtil do
  it 'parse_rules' do
    start = Time.now

    util = ::MustacheRender::FieldsFilterUtil.new
    util.empty?.should be_true

    util = ::MustacheRender::FieldsFilterUtil.new(
      :default => {
        :deals => [
          {
            :name => true,
            :age  => false
          }
        ],
        :shop => {
          :name => true
        }
      }
    )
    util.empty?.should be_false

    util.load(:default_missing).empty?.should be_true
    util.load(:default).empty?.should be_false

    (1..10000).each do |i|
      # 传递数组类型的效率要差！
      util.match?([:default, :deals]).should be_true
      util.match?([:default, :deals_missing]).should be_false

      util.hit?("default").should be_true
      util.match?("default#deals").should be_true
      util.match?("default#deals_missing").should be_false

      util.load(:default).empty?.should be_false

    end

    (Time.now - start).should < 0.5

    # rules = ::MustacheRender::FieldsFilterUtil.new(
    #   :shop => {
    #     :name => true,
    #     :address => false
    #   }
    # ).rules
    # rules.should == {"shop#name"=>true, "shop#address"=>false}

    # rules = ::MustacheRender::FieldsFilterUtil.new(
    #   :shop => {
    #     :deal => :wap,
    #     :name => false,
    #     :address => false,
    #     :nice? => false,
    #     :hello! => true,
    #     :like?  => false
    #   },
    #   :deal => {
    #     :urls => {
    #       :www => true,
    #       :wap => false
    #     }
    #   }
    # ).rules

  end
end

