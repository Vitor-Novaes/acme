# frozen_string_literal: true

describe V1::VariantsController, type: :controller do
  render_views

  describe 'GET /v1/variants' do
    let!(:variants) { create_list(:variant, 10) }
    let!(:category) { create(:category, name: 'Tremonti') }
    let!(:product) { create(:product, category: category) }
    let!(:variant) { create_list(:variant, 10, product: product) }

    context 'When normal request without params' do
      before(:example) { get :index }

      include_examples 'ok response'

      it 'Then return all of data with paginate default params' do
        expect(json_response[:variants].count).to eq(10)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with paginated fisrt page limited count' do
      before(:example) { get :index, params: { page: 1, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginate params setting' do
        expect(json_response[:variants].count).to eq(6)
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with paginated last page limited count' do
      before(:example) { get :index, params: { page: 4, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginated' do
        expect(json_response[:variants].count).to eq(2)
        expect(json_response[:metadata][:current_page]).to eq(4)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with sort by sold' do
      before(:example) { get :index, params: { sort_by_sales: 'DESC' } }

      include_examples 'ok response'

      it 'Then return all of data order most sold' do
        expect(json_response[:variants].count).to eq(10)
        expect(
          json_response[:variants].first[:sales] >
          json_response[:variants].last[:sales]
        ).to be_truthy
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with sort by sold and category' do
      before(:example) { get :index, params: { sort_by_sales: 'DESC', by_category: 'Tremonti' } }

      include_examples 'ok response'

      it 'Then return all of data order most sold by category' do
        expect(json_response[:variants].count).to eq(10)
        expect(
          json_response[:variants].first[:sales] >
          json_response[:variants].last[:sales]
        ).to be_truthy
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(10)
        expect(json_response[:metadata][:total_pages]).to eq(1)
      end
    end
  end
end
