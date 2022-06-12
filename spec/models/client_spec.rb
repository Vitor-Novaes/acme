# frozen_string_literal: true

describe Client, typ: :model do
  subject { FactoryBot.build(:client) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:orders) }

  it { should allow_value('mars@sirius.com').for(:email) }
  it { should_not allow_value('mars_to_sirius').for(:email) }
end
