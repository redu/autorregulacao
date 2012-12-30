FactoryGirl.define do
  factory :ar_exercise do
    sequence(:title) { |n| "Exercise number #{n}" }

    factory :complete_ar_exercise do
      ignore { questions_count 3 }
      association :user
      after(:create) do |exercise, evaluator|
        FactoryGirl.create_list(:complete_question, evaluator.questions_count,
                                ar_exercise: exercise)
      end
    end
  end
end
