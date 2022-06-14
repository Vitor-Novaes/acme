class Product < ApplicationRecord
  belongs_to :category
  has_many :variants, dependent: :destroy, inverse_of: :product
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

  validates :base_value, numericality: true, presence: true
  validates :name, presence: true, uniqueness: true
end