class InventoryResource < ApplicationRecord
  belongs_to :inventory
  belongs_to :resource
end
