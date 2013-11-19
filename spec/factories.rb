FactoryGirl.define do

  factory :dummy do
    name { Faker::Name.first_name }
  end
  # factory :brochure_request do
  #   salutation :mr
  #   sequence(:first_name) { |n| "#{ Faker::Name.first_name } #{ n }"}
  #   sequence(:last_name) { |n| "#{ Faker::Name.last_name } #{ n }"}
  #   sequence(:email) { |n| "#{ n }#{ Faker::Internet.email }" }
  #   country nil
  #   factory :brochure_request_with_boats do
  #     ignore do
  #       boats_count 5
  #     end

  #     after(:create) do |brochure_request, evaluator|
  #       FactoryGirl.create_list(:boat, evaluator.boats_count).each do |boat|
  #         brochure_request.boats << boat
  #       end
  #     end
  #   end
  # end
end