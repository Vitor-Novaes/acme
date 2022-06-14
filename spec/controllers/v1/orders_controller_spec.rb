# frozen_string_literal: true

describe V1::OrdersController, type: :controller do
  render_views

  describe 'GET /v1/orders' do
    let!(:orders) { create_list(:order, 20) }

    context 'When normal request without params' do
      before(:example) { get :index }

      include_examples 'ok response'

      it 'Then return all of data with paginate default params' do
        expect(json_response[:orders].count).to eq(10)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with paginated fisrt page limited count' do
      before(:example) { get :index, params: { page: 1, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginate params setting' do
        expect(json_response[:orders].count).to eq(6)
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with paginated last page limited count' do
      before(:example) { get :index, params: { page: 4, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginated' do
        expect(json_response[:orders].count).to eq(2)
        expect(json_response[:metadata][:current_page]).to eq(4)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end
  end

  describe 'GET /v1/orders/:id' do
    let!(:order) { create(:order, id: 1) }

    context 'When pass a valid param but not existent record' do
      before(:example) { get :show, params: { id: 2 } }

      include_examples 'not_found response'

      it 'Then return not found error' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Order with 'id'=2")
      end
    end

    context 'When pass a valid param and existent record' do
      before(:example) { get :show, params: { id: 1 } }

      include_examples 'ok response'

      it 'Then return information' do
        expect(json_response[:order][:id]).to eq(order.id)
        expect(json_response[:order][:client]).not_to be_blank
      end
    end
  end

  describe 'POST /v1/orders' do
    context 'When put invalid attributes' do
      let(:product) { create(:product, :with_variants, variant_count: 2) }
      let(:variant) { create(:variant, id: 3) }

      before do
        post :create, params: attributes_for(:order,
                                             code: '123456789098',
                                             status: 'Raining Blood',
                                             registers_attributes: [
                                               {
                                                 product_id: 1,
                                                 variant_id: 3,
                                                 quantity: 2
                                               },
                                               {
                                                 product_id: 1,
                                                 variant_id: 3,
                                                 quantity: 2
                                               }
                                             ])
      end

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:status]).to eq(['Invalid status'])
        expect(json_response[:errors][:registers]).to eq([
                                                           'Variant 3 doesnt belongs that product 1',
                                                           'Variant 100 doesnt belongs that product 600'
                                                         ])
        expect(json_response[:errors][:'registers.product']).to eq(['must exist'])
        expect(json_response[:errors][:'registers.variant']).to eq(['must exist'])
      end
    end

    context 'When missing some attributes' do
      before do
        post :create, params: attributes_for(:order,
                                             code: nil,
                                             status: nil,
                                             state: nil,
                                             address: nil,
                                             city: nil,
                                             net_value: nil)
      end

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:code]).to eq(["can't be blank"])
        expect(json_response[:errors][:status]).to eq(['Invalid status', "can't be blank"])
        expect(json_response[:errors][:state]).to eq(["can't be blank"])
        expect(json_response[:errors][:address]).to eq(["can't be blank"])
        expect(json_response[:errors][:city]).to eq(["can't be blank"])
        expect(json_response[:errors][:registers]).to eq(["can't be blank"])
        expect(json_response[:errors][:net_value]).to eq(['is not a number', "can't be blank"])
      end
    end

    context 'When put valid data' do
      let(:client) { create(:client) }
      let(:product) { create(:product, :with_variants, variant_count: 2) }

      before do
        post :create, params: attributes_for(
          :order,
          client_id: client.id,
          registers_attributes: [
            {
              product_id: 1,
              variant_id: 1,
              quantity: 2
            },
            {
              product_id: 1,
              variant_id: 2,
              quantity: 2
            }
          ]
        )
      end

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response).to have_key(:id)
      end
    end
  end

  describe 'PATCH /v1/orders/:id' do
    let!(:order) { create(:order, id: 1) }

    context 'When put invalid id' do
      before { patch :update, params: { id: 90, payment_date: '2022-07-13' } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Order with 'id'=90")
      end
    end

    context 'When put valid data' do
      before { patch :update, params: { id: order.id, payment_date: '2022-07-13', status: 'POSTING' } }

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response[:id]).to eq(order.id)
        expect(json_response[:payment_date]).to eq('2022-07-13T00:00:00.000Z')
        expect(json_response[:status]).to eq('POSTING')
      end
    end
  end

  describe 'DELETE /v1/orders/:id' do
    let!(:order) { create(:order, id: 1) }

    context 'When put invalid id' do
      before { delete :destroy, params: { id: 1000 } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Order with 'id'=1000")
      end
    end

    context 'When delete without errors' do
      before { delete :destroy, params: { id: order.id } }

      include_examples 'no_content response'

      it { expect { order.reload }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
