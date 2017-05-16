require 'rails_helper'

RSpec.describe InventoryResource, type: :model do
  describe "Associations" do
    it{ is_expected.to belong_to :inventory }
    it{ is_expected.to belong_to :resource }
  end
end
