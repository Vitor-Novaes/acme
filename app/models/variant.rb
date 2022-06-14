class Variant < ApplicationRecord
  belongs_to :product, inverse_of: :variants
  validates_presence_of :product

  validates :value, numericality: true, presence: true
  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp }, presence: true
  validates :code, presence: true
end
