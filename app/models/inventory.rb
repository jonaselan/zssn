class Inventory < ApplicationRecord
  has_many :inventory_resources
  has_many :resources, through: :inventory_resources
end
