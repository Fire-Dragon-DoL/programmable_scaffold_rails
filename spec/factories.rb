FactoryGirl.define do

  factory :dummy do
    name { Faker::Name.first_name }

    factory :dummy_invalid do
      will_invalidate true
    end
  end
end