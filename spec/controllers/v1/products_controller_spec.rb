# frozen_string_literal: true

describe V1::ProductsController, type: :controller do
  render_views

  describe 'GET /v1/products' do
    let!(:products) { create_list(:product, 20, :with_variants) }

    context 'When normal request without params' do
      before(:example) { get :index }

      include_examples 'ok response'

      it 'Then return all of data with paginate default params' do
        expect(json_response[:products].count).to eq(10)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with paginated fisrt page limited count' do
      before(:example) { get :index, params: { page: 1, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginate params setting' do
        expect(json_response[:products].count).to eq(6)
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with paginated last page limited count' do
      before(:example) { get :index, params: { page: 4, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginated' do
        expect(json_response[:products].count).to eq(2)
        expect(json_response[:metadata][:current_page]).to eq(4)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end
  end

  describe 'GET /v1/products/:id' do
    let!(:product) { create(:product, :with_variants, variant_count: 1, id: 1) }

    context 'When pass a valid param but not existent record' do
      before(:example) { get :show, params: { id: 2 } }

      include_examples 'not_found response'

      it 'Then return not found error' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Product with 'id'=2")
      end
    end

    context 'When pass a valid param and existent record' do
      before(:example) { get :show, params: { id: 1 } }

      include_examples 'ok response'

      it 'Then return product information and yours variants' do
        expect(json_response[:product][:id]).to eq(product.id)
        expect(json_response[:product][:variants]).not_to be_empty
        expect(json_response[:product][:variants].size).to eq(1)
      end
    end
  end

  describe 'POST /v1/products' do
    let(:category) { create(:category, id: 1) }

    context 'When put invalid attributes for products and variants' do
      before do
        post :create, params: attributes_for(:product,
                                             base_value: 'BR',
                                             name: 'Sepultura',
                                             category_id: category.id,
                                             variants_attributes: [
                                               {
                                                 code: 'Roots Bloody Roots',
                                                 value: 'Roots',
                                                 image: 'Bloody'
                                               }
                                             ])
      end

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:base_value]).to eq(['is not a number'])
        expect(json_response[:errors][:'variants.value']).to eq(['is not a number'])
        expect(json_response[:errors][:'variants.image']).to eq(['is invalid'])
      end
    end

    context 'When missing some attributes' do
      before do
        post :create, params: attributes_for(:product,
                                             base_value: '',
                                             name: '',
                                             category_id: '',
                                             variants_attributes: [
                                               {
                                                 code: 'Vacuity',
                                                 value: '',
                                                 image: ''
                                               }
                                             ])
      end

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:name]).to eq(["can't be blank"])
        expect(json_response[:errors][:base_value]).to eq(['is not a number', "can't be blank"])
        expect(json_response[:errors][:category]).to eq(['must exist'])
        expect(json_response[:errors][:'variants.value']).to eq(['is not a number', "can't be blank"])
        expect(json_response[:errors][:'variants.image']).to eq(['is invalid', "can't be blank"])
      end
    end

    context 'When put valid data' do
      before do
        post :create, params: attributes_for(:product,
                                             base_value: 19.9,
                                             name: 'Lamb of God',
                                             category_id: category.id,
                                             variants_attributes: [
                                               {
                                                 code: 'Momento Mori',
                                                 value: 39.9,
                                                 image: 'http://localhost'
                                               },
                                               {
                                                 code: 'Redneck',
                                                 value: 39.9,
                                                 image: 'http://localhost'
                                               }
                                             ])
      end

      include_examples 'ok response'

      it 'Then return product and create associate variants' do
        expect(json_response).to have_key(:id)
        expect(json_response[:base_value]).to eq('19.9')
        expect(json_response[:name]).to eq('Lamb of God')
        expect(json_response[:category_id]).to eq(category.id)
        expect(Variant.count).to eq(2)
      end
    end
  end

  describe 'PATCH /v1/products/:id' do
    let!(:product) { create(:product, id: 1, base_value: 10) }
    before do
      create(:variant, id: 1,
                       product_id: 1,
                       code: 'Bloodline',
                       value: 19,
                       image: 'http://localhost')
      create(:variant, id: 2,
                       product_id: 1,
                       code: 'The art of dying',
                       value: 19,
                       image: 'http://localhost')
    end

    context 'When put invalid id' do
      before { patch :update, params: { id: 90, base_value: '299,9' } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Product with 'id'=90")
      end
    end

    context 'When put valid data' do
      before do
        patch :update, params: {
          id: product.id,
          base_value: 20,
          variants_attributes: [
            {
              id: 1,
              code: 'Bloodline UPDATED'
            },
            {
              id: 2,
              _destroy: 1
            }
          ]
        }
      end

      include_examples 'ok response'

      it 'Then return success response and nested associations updated' do
        expect(json_response[:id]).to eq(product.id)
        expect(json_response[:base_value]).to eq('20.0')
        expect(Variant.count).to eq(1)
        expect(Variant.first.code).to eq('Bloodline UPDATED')
      end
    end
  end

  describe 'DELETE /v1/products/:id' do
    let!(:product) { create(:product, id: 1) }
    let!(:variant) { create(:variant, id: 1, product_id: 1) }

    context 'When put invalid id' do
      before { delete :destroy, params: { id: 1000 } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Product with 'id'=1000")
      end
    end

    context 'When delete without errors' do
      before { delete :destroy, params: { id: product.id } }

      include_examples 'no_content response'

      it 'Then delete product and variants association' do
        expect { product.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Variant.count).to eq(0)
      end
    end
  end
end
