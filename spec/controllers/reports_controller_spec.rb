require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:create_survivors) do
    create :survivor
    create :survivor, :infected_person
  end

  let(:create_survivors_with_resources) do
    surv = create(:survivor, :inventory_empty)
    person_infected = create(:survivor, :infected_person, :inventory_empty)

    am = create(:resource_ammunition)
    water = create(:resource_water)

    surv.inventory.inventory_resources.create(resource: water)
    person_infected.inventory.inventory_resources.create(resource: am)
  end

  describe 'GET #avg_infected' do
    it 'Return the percentage of infected persons' do
      create_survivors
      get :avg_infected
      expect(json_response['percentage']).to eq(50.0)
    end
  end

  describe 'GET #avg_non_infected' do
    it 'Return the percentage of no infected persons' do
      create_survivors
      get :avg_non_infected
      expect(json_response['percentage']).to eq(50.0)
    end
  end

  describe 'GET #avg_resource_per_person' do
    it 'Return average amount of each kind of resource by survivor' do
      create_survivors_with_resources
      get :avg_resource_per_person
      expect(json_response['avg_ammunition']).to eq(0.5)
      expect(json_response['avg_medication']).to eq(0.5)
      expect(json_response['avg_food']).to eq(0.0)
      expect(json_response['avg_water']).to eq(0.0)
    end
  end

  describe 'GET #points_lost_infected' do
    it 'Return number of points lost because of infected survivor' do
      create_survivors_with_resources
      get :points_lost_infected
      expect(json_response['number']).to eq(1)
    end
  end
end
