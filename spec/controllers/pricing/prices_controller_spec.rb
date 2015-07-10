require 'rails_helper'

RSpec.describe Pricing::PricesController, type: :controller do
  describe 'Prices API' do

    describe '#index' do
      before :each do
        @expected_prices = []
        (0..3).each { @expected_prices << FactoryGirl.create(:price) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the apartments in JSON' do
        body = JSON.parse(response.body)

        expect(body['prices']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_prices).to_json))
      end
    end

    describe '#show' do
      let(:expected_price) { FactoryGirl.create :price }

      context 'when the price is found' do
        before :each do
          get :show, {:id => expected_price.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the price in JSON' do
          body = JSON.parse(response.body)
          price = body['price']
          puts price

          expect(price['id']).to eq(expected_price.id)
          expect(price['number_of_night']).to eq(expected_price.number_of_night)
          expect(price['amount_cents']).to eq(expected_price.amount_cents)
          expect(price['amount_currency']).to eq(expected_price.amount_currency)
          expect(price['period'][0]['id']).to eq(expected_price.period.id)
          expect(price['period'][0]['name']).to eq(expected_price.period.name)
          expect(price['period'][0]['start_date']).to eq(expected_price.period.start_date.to_s)
          expect(price['period'][0]['end_date']).to eq(expected_price.period.end_date.to_s)
        end
      end

      context 'when the price is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end
    end

    describe '#create' do
      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:price => {:number_of_night => -5}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_price) { FactoryGirl.build(:price) }

        before :each do
          post :create, {:price => submitted_price.attributes}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates a Price with the given attributes values' do
          id = JSON.parse(response.body)['price']['id']


          created_price = Pricing::Price.find id
          expect(created_price.number_of_night).to eq(submitted_price.number_of_night)
          expect(created_price.amount_cents).to eq(submitted_price.amount_cents)
          expect(created_price.period.id).to eq(submitted_price.period.id)
        end
      end
    end
  end

end
