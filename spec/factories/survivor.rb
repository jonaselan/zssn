FactoryGirl.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.between(10, 40) }
    gender 'M'
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }
    infected false
    infection_occurrences 0
end
