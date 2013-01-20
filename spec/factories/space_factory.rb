FactoryGirl.define do
  factory :space do
    sequence(:name) { |n| "My super dupper Space no. #{n}" }
    sequence(:core_id)
  end
end
