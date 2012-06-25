require 'spec_helper'

describe Ferrety::StockFerret do
  it "can accept JSON parameters on initialize" do
    Ferrety::StockFerret.new('{"symbol":".dji"}').symbol.should == '.dji'
  end

  it "can accept Hash parameters on initialize" do
    Ferrety::StockFerret.new("symbol" => '.dji').symbol.should == '.dji'
  end

  context "in private methods" do
    before(:each) do 
      @ferret = Ferrety::StockFerret.new({})
      @ferret.symbol = ".dji"
      @ferret.instruction = "change"
      @ferret.stub(:watched_data).and_return(25)
    end

    it "alerts when a watched datum exceeds the high threshold" do
      @ferret.high_threshold = 20
      @ferret.search
      @ferret.alerts.size.should == 1
    end

    it "alerts when a watched datum exceeds the high threshold" do
      @ferret.low_threshold = 30
      @ferret.search
      @ferret.alerts.size.should == 1
    end

    it "does not alert when a watched datum is within thresholds" do
      @ferret.high_threshold = 30
      @ferret.low_threshold = 20
      @ferret.search
      @ferret.alerts.size.should == 0
    end
  end
end