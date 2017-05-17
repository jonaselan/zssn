class Resource < ApplicationRecord
  has_many :inventory_resources
  has_many :inventories, through: :inventory_resources
  
  enum name: [:water, :food, :medication, :ammunition]

  scope :by_name, -> (name) { find_by(name: name) }
end
