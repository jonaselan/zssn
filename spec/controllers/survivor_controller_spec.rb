require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  describe 'GET #report_infection' do
    it "return successful message when add occurrence" do
      survivor = create(:survivor, infection_occurrences: 1)
      get :report_infection, params: { id: survivor.id }
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['message']).to eq 'Flag the survivor!'
    end
    it "return message warning the person already dead" do
      survivor = create(:survivor, :infected_person)
      get :report_infection, params: { id: survivor.id }
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['message']).to eq 'Already dead :('
    end
  end
end
