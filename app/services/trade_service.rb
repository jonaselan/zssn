class TradeService
  class << self
    def is_a_valid_trade?(data)
      (count_point(data[:resources1]) == count_point(data[:resources2])) and !(data[:survivor1].infected || data[:survivor2].infected)
    end

    def make_the_trade(data)
      data[:survivor1].do_the_trade_with(data[:survivor2], data[:resources1])
      data[:survivor2].do_the_trade_with(data[:survivor1], data[:resources2])
    end

    private

    def count_point(resources)
      points = 0
      resources.split(',').each do |resource|
        resource = resource.split(':')
        points += resource[0].to_i * InventoryService.resource_name_to_point(resource[1])
      end
       points
    end

  end
end
