require 'market_beat'
require 'ferrety'

module Ferrety
  class StockFerret < Ferret
    attr_accessor :symbol, :instruction, :low_threshold, :high_threshold

    def initialize(params)
      super
      @symbol = @params["symbol"]
      @instruction = @params["term"]
      @low_threshold = @params["low_threshold"].to_i
      @high_threshold = @params["high_threshold"].to_i  
    end

    def search
      if watched_data.to_f < low_threshold || watched_data.to_f > high_threshold
        add_parsed_alert
      end
      @alerts
    end

    private

    def add_parsed_alert
      phrase = @instruction.upcase == "CHANGE" ? "has changed by" : "is trading at"
      add_alert("The stock #{@symbol} #{phrase} #{watched_data}.")
    end

    def watched_data
      case @instruction.upcase
      when "CHANGE" then MarketBeat.percent_change(@symbol)
      else MarketBeat.last_trade_real_time(@symbol)
      end
    end
  end
end
