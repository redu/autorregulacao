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
  end
end
