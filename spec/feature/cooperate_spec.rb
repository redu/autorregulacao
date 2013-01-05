# encoding: UTF-8
require 'spec_helper'

feature 'Cooperating' do
  let(:user) do
    FactoryGirl.create(:user)
  end
  let(:question) do
    FactoryGirl.create(:complete_question)
  end
  let(:empty_question) do
    FactoryGirl.create(:complete_question, answers_count: 0)
  end

  before do
    BaseController.any_instance.stub(:current_user).and_return(user)
  end

  context "when listing the answers" do
    scenario "user visits the answer index page" do
      visit "/questions/#{question.id}/answers"

      expect(page).to_not have_content "Ainda não há respostas"
      answer = question.answers.first.initial.truncate(40)
      expect(find '.table-with-borderradius tbody' ).to have_content answer
      expect(find '.table-with-borderradius .status' ).to have_content "Não"
      expect(find '.table-with-borderradius .status' ).to_not have_content "Sim"
      expect(find '.table-with-borderradius .status-cooperations' ).
        to have_content "1"
      question.answers.each do |a|
        expect(page).to have_selector "a[href='/answers/#{a.id}']"
      end
    end

    context "when there aren't answers" do
      scenario "user visits the answer index page" do
        visit "/questions/#{empty_question.id}/answers"

        expect(page).to have_content "Ops, Esta Questão Ainda Não Foi Respondida Por Seus Colegas"
      end
    end

    context "when the only answer is from current user" do
      scenario "user visits the answer index page" do
        question.answers.first.update_attribute(:user_id, user.id)
        visit "/questions/#{question.id}/answers"

        expect(page).to have_content \
          "Ops, Esta Questão Ainda Não Foi Respondida Por Seus Colegas"
      end
    end
  end

  context "when cooperating" do
    let(:answer) { question.answers.first }
    scenario "user vistis the answer page" do
      visit "/answers/#{answer.id}"

      %w(user_id answer_id recommendation rationale).each do |attr|
        expect(page).to have_selector("[name='cooperation_form[#{attr}]']")
      end
    end

    scenario "user cooperates" do
      visit "/answers/#{answer.id}"

      within('form') do
        fill_in 'cooperation_form[recommendation]', with: 'Lorem 12'
        fill_in 'cooperation_form[rationale]', with: 'Lorem 13'
      end
      click_button 'Responder'

      expect(page).to have_content 'Lorem 12'
      expect(page).to have_content 'Lorem 13'
      expect(page).to_not have_selector '.new_cooperation_form'
    end

    scenario "user cooperates with invalid data" do
      visit "/answers/#{answer.id}"

      within('form') do
        fill_in 'cooperation_form[recommendation]', with: ''
        fill_in 'cooperation_form[rationale]', with: ''
      end
      click_button 'Responder'

      expect(page).to have_content 'não pode ficar em branco'
    end

    scenario "user go back to Answers#index"
  end

  context "when feebacking" do
    let(:answer) do
      FactoryGirl.create(:complete_answer, cooperations_count: 0) do |answer|
        answer.cooperations << FactoryGirl.create(:cooperation_with_user)
      end
    end
    let(:question) do
      FactoryGirl.create(:complete_question, answers_count: 0) do |question|
        question.answers << answer
      end
    end
    before do
      BaseController.any_instance.stub(:current_user).and_return(answer.user)
    end
    scenario "user visits question page" do
      visit "/questions/#{question.id}"

      %w(user_id feedback_statement feedback_reflection feedback_accepted).
        each do |attr|
          expect(page).to have_selector("[name='feedback_form[#{attr}]']")
        end
    end

    scenario "user is able to answer a cooperation" do
      visit "/questions/#{question.id}"

      within('.positive-feedback-form form') do
        fill_in 'feedback_form[feedback_statement]', with: 'Lorem feedback statement'
        fill_in 'feedback_form[feedback_reflection]', with: 'Lorem feedback reflection'
        click_button 'accept_recommendation'
      end

      expect(page).to_not have_selector('.positive-feedback-form form')
      expect(page).to_not have_selector('.negative-feedback-form form')
    end

    scenario "user feedback cooperation with invalid data" do
      visit "/questions/#{question.id}"

      within('.positive-feedback-form form') do
        fill_in 'feedback_form[feedback_statement]', with: ''
        fill_in 'feedback_form[feedback_reflection]', with: ''
      end
      click_button 'accept_recommendation'

      expect(page).to have_content 'não pode ficar em branco'
    end
  end
end
