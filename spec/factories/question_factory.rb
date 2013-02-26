FactoryGirl.define do
  factory :question do
    sequence(:position)
    sequence(:title) { |n| "Question number #{n}" }
    statement 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    representation { FactoryGirl.build(:lecture_representation) }

    factory :complete_question do
      ignore { answers_count 1 }
      after(:create) do |question, evaluator|
        FactoryGirl.create_list(:complete_answer, evaluator.answers_count,
                                question: question)
      end
    end
  end
end
