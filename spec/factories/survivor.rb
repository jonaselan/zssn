FactoryGirl.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.between(10, 40) }
    gender 'M'
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }
    infected false
    infection_occurrences 0

    factory :infected_person do
      infected true
      infection_occurrences 3
    end

    trait :without_inventory do
      after :create do |survivor|
        survivor.inventory = nil
      end
    end

    trait :with_inventory do
      after :create do |ss|
        create :inventory_with_resources, survivor_id: ss.id
      end
    end

  end
end
