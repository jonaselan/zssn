class Resource < ApplicationRecord
  has_many :inventory_resouces
  has_many :inventories, through: :inventory_resources
end
