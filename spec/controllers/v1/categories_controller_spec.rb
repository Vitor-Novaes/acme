# frozen_string_literal: true

describe V1::CategoriesController, type: :controller do
  render_views

  describe 'GET /v1/categories' do
    let!(:category) { create_list(:category, 20) }

    context 'When normal request without params' do
      before(:example) { get :index }

      include_examples 'ok response'

      it 'Then return all of data with paginate default params' do
        expect(json_response[:categories].count).to eq(10)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(2)
      end
    end

    context 'When request with paginated fisrt page limited count' do
      before(:example) { get :index, params: { page: 1, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginate params setting' do
        expect(json_response[:categories].count).to eq(6)
        expect(json_response[:metadata][:current_page]).to eq(1)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end

    context 'When request with paginated last page limited count' do
      before(:example) { get :index, params: { page: 4, per_page: 6 } }

      include_examples 'ok response'

      it 'Then return all of data with paginated' do
        expect(json_response[:categories].count).to eq(2)
        expect(json_response[:metadata][:current_page]).to eq(4)
        expect(json_response[:metadata][:total_count]).to eq(20)
        expect(json_response[:metadata][:total_pages]).to eq(4)
      end
    end
  end

  describe 'POST /v1/categories' do
    context 'When missing some attributes' do
      before { post :create, params: attributes_for(:category, name: nil) }

      include_examples 'unprocess_entity response'

      it 'Then return error type validation' do
        expect(json_response[:errors][:name]).to eq(["can't be blank"])
      end
    end

    context 'When put valid data' do
      before do
        post :create, params: attributes_for(:category)
      end

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response).to have_key(:id)
      end
    end
  end

  describe 'PATCH /v1/categories/:id' do
    let(:category) { create(:category, id: 1) }

    context 'When put invalid id' do
      before { patch :update, params: { id: 90, name: 'The Haviest Matter of the universe' } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Category with 'id'=90")
      end
    end

    context 'When put valid data' do
      before { patch :update, params: { id: category.id, name: 'The Haviest Matter of the universe' } }

      include_examples 'ok response'

      it 'Then return success response' do
        expect(json_response[:id]).to eq(category.id)
        expect(json_response[:name]).to eq('The Haviest Matter of the universe')
      end
    end
  end

  describe 'DELETE /v1/categories/:id' do
    let!(:category) { create(:category, id: 1) }
    let!(:products) { create_list(:product, 5, category_id: 1) }

    context 'When put invalid id' do
      before { delete :destroy, params: { id: 1000 } }

      include_examples 'not_found response'

      it 'Then return not found error response' do
        expect(Product.count).to eq(5)
        expect(json_response[:errors][:message]).to eq("Couldn't find Category with 'id'=1000")
      end
    end

    context 'When delete without errors' do
      before { delete :destroy, params: { id: category.id } }

      include_examples 'no_content response'

      it 'Then delete category and products associations' do
        expect { category.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Product.count).to eq(0)
      end
    end
  end
end
