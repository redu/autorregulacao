# encoding: UTF-8
require 'spec_helper'

feature 'Answering question' do
  let(:user) do
    FactoryGirl.create(:user)
  end
  let(:question) do
    FactoryGirl.create(:complete_question)
  end

  before do
    BaseController.any_instance.stub(:current_user).and_return(user)
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
