shared_examples 'content-type json' do
  it 'should respond with content type \'application/json\'' do
    expect(response.content_type).to eq 'application/json; charset=utf-8'
  end
end

shared_examples 'ok response' do
  it { expect(response).to have_http_status(:ok) }

  include_examples "content-type json"
end

shared_examples 'created response' do
  it { expect(response).to have_http_status(:created) }

  include_examples "content-type json"
end

shared_examples 'not_found response' do
  it { expect(response).to have_http_status(:not_found) }

  include_examples "content-type json"
end

shared_examples 'unprocess_entity response' do
  it { expect(response).to have_http_status(:unprocessable_entity) }

  include_examples "content-type json"
end

shared_examples 'no_content response' do
  it { expect(response).to have_http_status(:no_content) }
end
