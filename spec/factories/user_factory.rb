FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user.no.#{n}@example.com" }
    sequence(:login) { |n| "foobar#{n}" }
    sequence(:name) { |n| "Mr. Foo Bar #{n}" }
    sequence(:token) { |n| "myawesometoken#{n}" }
    sequence(:uid)
  end
end
