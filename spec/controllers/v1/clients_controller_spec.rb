# frozen_string_literal: true

describe V1::ClientsController, type: :controller do
  render_views

  describe 'GET /v1/clients' do
    let!(:clients) { create_list(:client, 20) }

    context 'When normal request without params' do
      before(:example) { get :index }

      include_examples 'ok response'

      it 'Then return all of data with paginate default params' do
        expect(json_response[:clients].count).to eq(10)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with paginated fisrt page limited count' do
      before(:example) { get :index, params: { page: 1, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginate params setting' do
        expect(json_response[:clients].count).to eq(6)
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with paginated last page limited count' do
      before(:example) { get :index, params: { page: 4, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginated' do
        expect(json_response[:clients].count).to eq(2)
        expect(json_response[:metadata][:current_page]).to eq(4)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end
  end

  describe 'GET /v1/clients/:id' do
    let!(:client) { create(:client, id: 1) }

    context 'When pass a valid param but not existent record' do
      before(:example) { get :show, params: { id: 2 } }

      include_examples 'not_found response'

      it 'Then return not found error' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Client with 'id'=2")
      end
    end

    context 'When pass a valid param and existent record' do
      before(:example) { get :show, params: { id: 1 } }

      include_examples 'ok response'

      it { expect(json_response[:client][:id]).to eq(client.id) }
    end
  end

  describe 'POST /v1/clients' do
    context 'When put invalid attributes' do
      before do
        post :create, params: attributes_for(:client,
                                             name: 'where dragons dwell',
                                             email: 'Flying Whales')
      end

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:email]).to eq(['is invalid'])
      end
    end

    context 'When missing some attributes' do
      before { post :create, params: attributes_for(:client, name: nil, email: nil) }

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:name]).to eq(["can't be blank"])
        expect(json_response[:errors][:email]).to eq(["can't be blank", 'is invalid'])
      end
    end

    context 'When put valid data' do
      before do
        post :create, params: attributes_for(:client)
      end

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response).to have_key(:id)
      end
    end
  end

  describe 'PATCH /v1/clients/:id' do
    let(:client) { create(:client, id: 1) }

    context 'When put invalid id' do
      before { patch :update, params: { id: 90, name: 'The Haviest Matter of the universe' } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Client with 'id'=90")
      end
    end

    context 'When put valid data' do
      before { patch :update, params: { id: client.id, name: 'The Haviest Matter of the universe' } }

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response[:id]).to eq(client.id)
        expect(json_response[:name]).to eq('The Haviest Matter of the universe')
      end
    end
  end

  describe 'DELETE /v1/clients/:id' do
    let(:client) { create(:client, id: 1) }

    context 'When put invalid id' do
      before { delete :destroy, params: { id: 1000 } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Client with 'id'=1000")
      end
    end

    context 'When delete without errors' do
      before { delete :destroy, params: { id: client.id } }

      include_examples 'no_content response'

      it { expect { client.reload }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
