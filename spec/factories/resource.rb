FactoryGirl.define do
  factory :resource do
    point 1
    name 0

    factory :resource_ammunition do
      point 1
      name 'ammunition'
    end

    factory :resource_medication do
      point 2
      name 'medication'
    end

    factory :resource_food do
      point 3
      name 'food'
    end

    factory :resource_water do
      point 4
      name 'water'
    end
  end
end
