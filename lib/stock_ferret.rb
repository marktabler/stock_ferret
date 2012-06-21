require 'market_beat'
require 'ferrety_ferret'

module Ferrety
  class StockFerret < Ferret

    def search(symbol, instruction, low_threshold, high_threshold)
      watched_data = parse_instruction(symbol, instruction)
      if watched_data.to_f < low_threshold || watched_data.to_f > high_threshold
        add_parsed_alert(symbol, instruction, watched_data)
      end
      @alerts
    end

    private

    def add_parsed_alert(symbol, instruction, watched_data)
      phrase = instruction.upcase == "CHANGE" ? "has changed by" : "is trading at"
      add_alert("The stock #{symbol} #{phrase} #{watched_data}.")
    end

    def parse_instruction(symbol, instruction)
      case instruction.upcase
      when "CHANGE" then MarketBeat.percent_change(symbol)
      else MarketBeat.last_trade_real_time(symbol)
      end
    end
  end
end
