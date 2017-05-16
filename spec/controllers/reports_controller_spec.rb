require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:create_survivors) do
    create :survivor
    create :infected_person
  end

  let(:create_survivors_with_items) do
    create(:infected_person, :with_inventory)
    create(:survivor, :with_inventory)
  end

  describe 'GET #avg_infected' do
    it 'Return the percentage of infected persons' do
      create_survivors
      get :avg_infected
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['percentage']).to eq(50.0)
    end
  end

  describe 'GET #avg_non_infected' do
    it 'Return the percentage of no infected persons' do
      create_survivors
      get :avg_non_infected
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['percentage']).to eq(50.0)
    end
  end

  describe 'GET #avg_item_per_person' do
    it 'Return average amount of each kind of resource by survivor' do
      create_survivors_with_items
      get :avg_item_per_person
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['avg_ammunition']).to eq(0.0)
      expect(answer['avg_medication']).to eq(0.5)
      expect(answer['avg_food']).to eq(0.0)
      expect(answer['avg_water']).to eq(0.5)
    end
  end

  describe 'GET #points_lost_infected' do
    it 'Return number of points lost because of infected survivor' do
      create_survivors_with_items
      get :points_lost_infected
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['number']).to eq(2)
    end
  end
end