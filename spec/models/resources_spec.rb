require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe "Associations" do
    it{ is_expected.to have_many :inventory_resources }
    it{ is_expected.to have_many(:inventories).through(:inventory_resources) }
  end
end
