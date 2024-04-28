require 'rails_helper'

RSpec.describe '/cars (Included CanMan::Api::Authorize)', type: :request do
  before(:all) { Right.maintain! }
  after(:all) { Right.delete_all }

  let(:user) { create(:user) }
  let(:admin) { create(:role, name: 'admin', rights: [Right.find_by!(key: '*#*')]) }
  let(:cars) { create(:role, name: 'cars', rights: [Right.find_by!(key: 'cars#*')]) }
  let(:cars_index) { create(:role, name: 'cars_index', rights: [Right.find_by!(key: 'cars#index')]) }
  let(:posts) { create(:role, name: 'posts', rights: [Right.find_by!(key: 'posts#*')]) }

  before do
    allow_any_instance_of(CarsController).to receive(:current_user).and_return(user)
  end

  describe 'without any rights' do
    before { user.roles << posts }

    it 'returns forbidden on index' do
      get cars_path
      expect(response).to have_http_status(:forbidden)
    end

    it 'hold an forbidden message' do
      get cars_path
      expect(JSON.parse(response.body)['error']).to eq("You don't have the right cars#index")
    end
  end

  describe 'with admin rights' do
    before { user.roles << admin }

    it 'returns success on index' do
      get cars_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'with cars rights' do
    before { user.roles << cars }

    it 'returns success on index' do
      get cars_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'with cars_index rights' do
    before { user.roles << cars_index }

    it 'returns success on index' do
      get cars_path
      expect(response).to have_http_status(:success)
    end

    it 'returns false on show' do
      get car_path(1)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
