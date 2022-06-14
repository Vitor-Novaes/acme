# frozen_string_literal: true

describe Variant, type: :model do
  subject { FactoryBot.build(:variant) }

  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:image) }
  it { should validate_numericality_of(:value) }

  it { should belong_to(:product).inverse_of(:variants) }
  it { should validate_presence_of(:product) }

  it { should allow_value('http://marstosirius.com').for(:image) }
  it { should_not allow_value('mars_to_sirius').for(:image) }
end
