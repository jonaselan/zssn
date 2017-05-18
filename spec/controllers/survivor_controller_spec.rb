require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  let(:convert_response) { JSON.parse(response.body).with_indifferent_access }

  describe 'GET #report_infection' do
    it "return successful message when add occurrence" do
      survivor = create(:survivor, infection_occurrences: 1)
      get :report_infection, params: { id: survivor.id }
      answer = convert_response
      expect(answer['message']).to eq 'Flag the survivor!'
    end
    it "return message warning the person already dead" do
      person = create(:survivor, :infected_person)
      get :report_infection, params: { id: person.id }
      answer = convert_response
      expect(answer['message']).to eq 'Already dead :('
    end
  end

  describe 'PUT #trade' do
    let(:survivor_with_inventory) { create(:survivor, :with_inventory) }

    context "is invalid" do
      before :each do
        @survivor = survivor_with_inventory
      end
      it "with one infected person" do
        survivor = create(:survivor, :infected_person)
        put :trade, params: { survivor1_id: @survivor, resources1: '1:medication', survivor2_id: survivor, resources2: '2:medication' }
        answer = convert_response
        expect(answer['message']).to eq("Resource's points don't match or exist one person infected")
      end
      it "with no match points between survivors" do
        survivor = survivor_with_inventory
        put :trade, params: { survivor1_id: @survivor, resources1: '1:medication', survivor2_id: survivor, resources2: '2:medication' }
        answer = convert_response
        expect(answer['message']).to eq("Resource's points don't match or exist one person infected")
      end
      it "when try make a trade with survivor non-existent" do
        put :trade, params: { survivor1_id: 5, resources1: '1:medication', survivor2_id: 4, resources2: '2:medication' }
        answer = convert_response
        expect(answer['message']).to eq("Survivor not exist")
      end
      it "when try make a trade with survivor's resource non-existent" do
        survivor = create(:survivor, :inventory_empty)
        put :trade, params: { survivor1_id: @survivor, resources1: '2:water', survivor2_id: survivor, resources2: '4:medication' }
        answer = convert_response
        expect(answer['message']).to eq("Resource not found")
      end
    end

    context 'is valid' do
      before do
        @survivor1 = create(:survivor, :inventory_empty)
        @res1 = create(:resource_water)
        @survivor1.inventory.inventory_resources.create(resource: @res1)

        @survivor2 = create(:survivor, :inventory_empty)
        @res2 = create(:resource_food)
        @res3 = create(:resource_ammunition)
        @survivor2.inventory.inventory_resources.create(resource: @res2)
        @survivor2.inventory.inventory_resources.create(resource: @res3)

        put :trade, params: { survivor1_id: @survivor1.id, resources1: '1:water', survivor2_id: @survivor2.id, resources2: '1:food,1:ammunition' }
      end
      it "when both obey the conditions" do
        answer = JSON.parse(response.body).with_indifferent_access
        expect(answer['message']).to eq("Trade finished!")
      end
      context 'survivor which gives the resource' do
        it "it must have the resource deleted from its inventory" do
          expect(@survivor1.inventory.resources).to_not contain_exactly(@res1)
          expect(@survivor2.inventory.resources).to_not contain_exactly(@res2)
        end
      end
      context 'survivor which receives the resource' do
        it 'must have the resource given by the trade on its inventory' do
          expect(@survivor1.inventory.resources).to contain_exactly(@res2, @res3)
          expect(@survivor2.inventory.resources).to contain_exactly(@res1)
        end
      end
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
        answer = convert_response
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
    before do
      @survivor = create(:survivor)
    end

    it "assigns the requested survivor to @survivor" do
      get :show, params: { id: @survivor.id }
      expect(assigns(:survivor)).to be_a(Survivor)
    end
    it 'is invalid when try show nonexist survivor' do
      expect { get :show, params: {id: 2}  }.to raise_error(ActiveRecord::RecordNotFound)
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
    it 'is invalid when try delete nonexist survivor' do
      expect { delete :destroy, params: {id: 2}  }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
