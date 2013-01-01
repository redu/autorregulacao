# encoding: UTF-8
require 'spec_helper'

describe 'Answering question', type: :feature do
  let(:user) do
    FactoryGirl.create(:user)
  end
  let(:question) do
    FactoryGirl.create(:complete_question)
  end

  before do
    BaseController.any_instance.stub(:current_user).and_return(user)
  end

  it "shows the answering form" do
    visit "/questions/#{question.id}"

    %w(user_id question_id initial rationale reflection).each do |attr|
      expect(page).to have_selector "[name='answer_form[#{attr}]']"
    end
  end

  it "shows the link to the answers list" do
    visit "/questions/#{question.id}"

    expect(page).to have_selector "a[href='/questions/#{question.id}/answers']"
  end

  it "rerenders the answering form when there are validation errors" do
    visit "/questions/#{question.id}"

    within('form') do
      fill_in 'answer_form[initial]', with: ''
      fill_in 'answer_form[rationale]', with: ''
      fill_in 'answer_form[reflection]', with: ''
    end
    click_button 'Responder'

    expect(page).to have_content 'não pode ficar em branco'
  end

  it "shows the answers once answered" do
    visit "/questions/#{question.id}"
    within('form') do
      fill_in 'answer_form[initial]', with: 'Lorem 1'
      fill_in 'answer_form[rationale]', with: 'Lorem 2'
      fill_in 'answer_form[reflection]', with: 'Lorem 3'
    end
    click_button 'Responder'

    expect(page).to have_content 'Lorem 1'
    expect(page).to have_content 'Lorem 2'
    expect(page).to have_content 'Lorem 3'
  end

end
