# frozen_string_literal: true

describe Order, type: :model do
  subject { FactoryBot.build(:order) }

  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:net_value) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:code) }
  it { should validate_numericality_of(:net_value) }
  it { should validate_uniqueness_of(:code).case_insensitive }

  it { should allow_value('SENT').for(:status) }
  it { should allow_value('WAITING').for(:status) }
  it { should allow_value('PRODUCTION').for(:status) }
  it { should allow_value('CANCELED').for(:status) }
  it { should allow_value('POSTING').for(:status) }
  it { should_not allow_value('FF').for(:status) }

  it { should belong_to(:client) }
  it { should have_many(:registers) }
  it { should have_many(:products).through(:registers) }
end
