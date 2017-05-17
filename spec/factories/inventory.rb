FactoryGirl.define do
  factory :inventory do
    survivor

    factory :inventory_with_resources do
      transient do
        resource_count 1
      end

      after(:create) do |inventory, evaluator|
        create_list(:inventory_with_water, evaluator.resource_count, inventory: inventory)
      end
    end

    factory :inventory_with_many_resources do
      after(:create) do |inventory|
        create_list(:inventory_with_medication, 2, inventory: inventory)
      end
    end

  end
end
