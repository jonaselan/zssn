FactoryGirl.define do
  factory :inventory_resource do
    inventory
    resource

    factory :inventory_with_water do
      after :create do |inventory_resource|
        create(:resource_water, inventory_resources: [inventory_resource])
      end
    end

    factory :inventory_with_medication do
      after :create do |inventory_resource|
        create(:resource_medication, inventory_resources: [inventory_resource])
      end
    end

  end
end
