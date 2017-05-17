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
      person = create(:infected_person)
      get :report_infection, params: { id: person.id }
      answer = JSON.parse(response.body).with_indifferent_access
      expect(answer['message']).to eq 'Already dead :('
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before :each do
        resouce = create(:resource_ammunition)
        post :create, params:
                                  { name: 'Survivor', age: 3, gender: true, latitude: '35.202828',
                                    longitude: '5.811593', infected: false, infection_occurrences: 0,
                                      inventory_attributes: {
                                        inventory_resources_attributes: [{
                                  	  		resource_id: resouce.id
                                  	  	}]
                                      }
                                  }
                              
      end

      let(:survivor) { Survivor.first }
      let(:survivor_inventory) { survivor.inventory }
      let(:survivor_resources) { survivor.inventory.resources }
      let(:survivor_inventory_resources) { survivor.inventory.inventory_resources }

      it 'render the value save' do
        answer = JSON.parse(response.body).with_indifferent_access
        expect(answer.as_json.first(7)).to eq(assigns(:survivor).as_json.first(7))
      end

      it 'get 201 status' do
        expect(response.status).to eq 201
      end

      it 'save the new survivors in the db' do
        expect(Survivor.count).to eq 1
      end

      it 'creates a inventory related with survivor' do
        expect(survivor_inventory).to match Inventory.first
      end

      it "creates resources related with survivor's inventory" do
        expect(survivor_resources.first.name).to match 'ammunition'
      end

      # TODO
      # context 'without valid attributes' do
      #   it 'does not save the survivor in db' do
      #   end
      # end
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "assigns the index survivor to @survivor" do
      survivors = create_list(:survivor, 3)
      get :index
      expect(assigns(:survivors)).to match_array(survivors)
    end
  end

  describe 'GET #show' do
    it "assigns the requested survivor to @survivor" do
      survivor = create(:survivor)
      get :show, params: { id: survivor.id }
      expect(assigns(:survivor)).to be_a(Survivor)
    end
  end

  describe 'PATCH #update' do
    let (:reload) { @survivor.reload }
    before :each do
      @survivor = create(:survivor,
      latitude: '-16.346867430278824',
      longitude: '-48.948227763175964',
      name: 'Zezé',
      age: 20)
    end

    context 'valid attributes' do
      it "change the survivor's location" do
        patch :update, params: { id: @survivor.id, latitude: '16', longitude: '48' }
        reload
        expect(@survivor.latitude).to eq('16')
        expect(@survivor.longitude).to eq('48')
      end
      it "locates the requested @survivor" do
        patch :update, params: { id: @survivor.id, survivor: attributes_for(:survivor) }
        expect(assigns(:survivor)).to eq(@survivor)
      end

      it "changes @survivor's attributes" do
        patch :update, params: { id: @survivor.id, name: 'Chico', age: 21 }
        reload
        expect(@survivor.name).to eq('Chico')
        expect(@survivor.age).to eq(21)
      end

      it 'get 200 status' do
        patch :update, params: { id: @survivor.id, survivor: attributes_for(:survivor) }
        expect(response.status).to eq(200) # Sucess
      end
    end

    context 'invalid attributes' do
      it "don't save change the survivor's information" do
        patch :update, params: { id: @survivor.id, name: nil, age: 21 }
        reload
        expect(@survivor.name).to eq('Zezé')
        expect(@survivor.age).not_to eq(21)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @survivor = create(:survivor)
    end

    it 'deletes the survivor' do
      expect {
        delete :destroy, params: {id: @survivor.id}
      }.to change(Survivor, :count).by(-1)
    end

    it 'get status 204' do
      delete :destroy, params: {id: @survivor.id}
      expect(response.status).to eq 204 # No content
    end
  end

end
