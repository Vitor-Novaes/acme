class Register < ApplicationRecord
  belongs_to :product
  belongs_to :order
  belongs_to :variant
  before_validation :default_to_one_quantity, on: :create

  validates :quantity, presence: true, numericality: { other_than: 0 }

  private

  def default_to_one_quantity
    self.quantity = 1 if quantity.blank?
  end
end
