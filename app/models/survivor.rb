class Survivor < ApplicationRecord
  has_one :inventory
  has_many :inventory_resources, through: :inventory
end
