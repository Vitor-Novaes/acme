class Product < ApplicationRecord
  scope :sort_by_sales, lambda { |params|
    joins(:variants)
      .group('products.id')
      .order("sum(variants.sales) #{params[:sort_by_sales] || 'DESC'}")
  }

  scope :by_category, lambda { |params|
    joins(:category).where(category: { name: params[:by_category] })
  }

  belongs_to :category
  has_many :variants, dependent: :destroy, inverse_of: :product
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

  has_many :registers
  has_many :orders, through: :registers

  validates :base_value, numericality: true, presence: true
  validates :name, presence: true, uniqueness: true

  def total_sales
    variants.sum(&:sales)
  end
end
