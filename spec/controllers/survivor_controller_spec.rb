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
      it 'save the new survivors in the db' do
        expect {
          post :create, params: attributes_for(:survivor)
        }.to change(Survivor, :count).by(1)
      end

      it 'render the value save' do
        post :create, params: attributes_for(:survivor)
        answer = JSON.parse(response.body).with_indifferent_access
        expect(answer.as_json.first(7)).to eq(assigns(:survivor).as_json.first(7))
      end

      it 'get 201 status' do
        post :create, params: attributes_for(:survivor)
        expect(response.status).to eq 201
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
    before :each do
      @survivor = create(:survivor,
      latitude: '-16.346867430278824',
      longitude: '-48.948227763175964',
      name: 'Zezé',
      age: 20)
    end
    let (:reload) { @survivor.reload }

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
