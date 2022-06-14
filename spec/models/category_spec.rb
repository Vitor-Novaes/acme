# frozen_string_literal: true

describe Category, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:products) }
end
