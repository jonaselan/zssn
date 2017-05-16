class Survivor < ApplicationRecord
  has_one :inventory
  has_many :inventory_resources, through: :inventory

  accepts_nested_attributes_for :inventory
end
