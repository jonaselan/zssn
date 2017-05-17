class InventoryService
  class << self
    def resource_name_to_point(resource)
      if resource == 'ammunition'
        return 1
      elsif resource == 'medication'
        return 2
      elsif resource == 'food'
        return 3
      elsif resource == 'water'
        return 4
      end
    end
  end
end
