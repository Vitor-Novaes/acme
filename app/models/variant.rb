class Variant < ApplicationRecord
  scope :sort_by_sales, lambda { |params|
    group('id')
      .order("sum(sales) #{params[:sort_by_sales] || 'DESC'}")
  }

  scope :by_category, lambda { |params|
    joins(product: :category).where(category: { name: params[:by_category] })
  }

  belongs_to :product, inverse_of: :variants
  validates_presence_of :product

  validates :value, numericality: true, presence: true
  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp }, presence: true
  validates :code, presence: true
end
