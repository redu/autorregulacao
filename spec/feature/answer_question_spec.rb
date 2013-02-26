# encoding: UTF-8
require 'feature_spec_helper'

feature 'Answering question' do
  let(:user) do
    FactoryGirl.create(:user)
  end
  let(:exercise) do
    FactoryGirl.create(:complete_ar_exercise, space: FactoryGirl.create(:space))
  end
  let(:question) do
    exercise.questions.first
  end

  before do
    SpaceRemoteService.any_instance.stub(:users) do
      [Redu::User.new(name: "Foo", email: "abc@def.gh")]
    end
    mock_provider(user)
    login_with_oauth
  end

  scenario "user vists the question page" do
    visit "/questions/#{question.id}"

    %w(user_id question_id initial rationale reflection).each do |attr|
      expect(page).to have_selector "[name='answer_form[#{attr}]']"
    end
    expect(page).to have_selector "a[href='/questions/#{question.id}/answers']"
  end

  scenario "user answers the question with invalid data" do
    visit "/questions/#{question.id}"

    answer_question!('', '', '')

    expect(page).to have_content 'não pode ficar em branco'
  end

  scenario "user answers the question" do
    visit "/questions/#{question.id}"

    answer_question!

    expect(page).to have_content 'Lorem 1'
    expect(page).to have_content 'Lorem 2'
    expect(page).to have_content 'Lorem 3'
  end

  scenario "user visits a question already answered by him" do
    visit "/questions/#{question.id}"

    answer_question!

    expect(page).to_not have_selector('form')
  end

  def answer_question!(initial='Lorem 1', rationale='Lorem 2', reflection='Lorem 3')
    within('form') do
      fill_in 'answer_form[initial]', with: initial
      fill_in 'answer_form[rationale]', with: rationale
      fill_in 'answer_form[reflection]', with: reflection
    end
    click_button 'Responder'
  end
end
