require 'rails_helper'

RSpec.describe Apartment::ApartmentsController, type: :controller do
  describe 'Apartments API' do

    describe '#index' do
      before :each do
        @expected_apartments = []
        (0..3).each { @expected_apartments << FactoryGirl.create(:apartment) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the customers in JSON' do
        body = JSON.parse(response.body)

        expect(body['apartments']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_apartments).to_json))

      end
    end
  end

  describe '#show' do
    let(:expected_apartment) { FactoryGirl.create :apartment }

    context 'when the apartment is found' do
      before :each do
        get :show, {:id => expected_apartment.id}
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns the apartment in JSON' do
        body = JSON.parse(response.body)
        customer = body['apartment']

        expect(customer['id']).to eq(expected_apartment.id)
        expect(customer['name']).to eq(expected_apartment.name)
        expect(customer['capacity']).to eq(expected_apartment.capacity)
        expect(customer['description']).to eq(expected_apartment.description)
      end
    end

    context 'when the apartment is not found' do
      it 'responds with 404' do
        get :show, {:id => 2}
        expect(response).to be_not_found
      end
    end
  end


end