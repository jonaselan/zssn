class InventoryResource < ApplicationRecord
  belongs_to :inventory, optional: true
  belongs_to :resource, optional: true
end
