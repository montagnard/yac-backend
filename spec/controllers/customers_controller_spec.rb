require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'Customers API' do

    describe '#index' do
      let(:expected_customers) {Customer.all}

      before :each do
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the customers in JSON' do
        body = JSON.parse(response.body)

        expect(body['customers']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_customers).to_json))

      end
    end

    describe '#show' do
      let(:expected_customer) {FactoryGirl.create :customer}

      context 'when the customer is found' do
        before :each do
          get :show, {:id => expected_customer.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the customer in JSON' do
          body = JSON.parse(response.body)
          customer = body['customer']

          expect(customer['id']).to eq(expected_customer.id)
          expect(customer['first_name']).to eq(expected_customer.first_name)
          expect(customer['last_name']).to eq(expected_customer.last_name)
          expect(customer['email']).to eq(expected_customer.email)
          expect(customer['phone']).to eq(expected_customer.phone)
        end
      end

      context 'when the customer is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end
    end
  end
end
