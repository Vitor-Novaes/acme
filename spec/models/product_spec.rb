# frozen_string_literal: true

describe Product, type: :model do
  subject { FactoryBot.build(:product) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:base_value) }
  it { should validate_numericality_of(:base_value) }
  it { should validate_uniqueness_of(:name) }

  it { should belong_to(:category) }
  it { should have_many(:variants).inverse_of(:product) }
  it { should accept_nested_attributes_for(:variants).allow_destroy(true) }
end
