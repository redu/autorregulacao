FactoryGirl.define do
  factory :answer do
    initial 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    rationale 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    reflection 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'

    factory :complete_answer do
      association :user
      ignore { cooperations_count 1 }

      after(:create) do |answer, evaluator|
        FactoryGirl.create_list(:complete_cooperation, evaluator.cooperations_count,
                                answer: answer)
      end
    end
  end
end
