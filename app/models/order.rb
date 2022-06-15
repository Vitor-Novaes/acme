class Order < ApplicationRecord
  include ImportData

  STATUS = %w[SENT WAITING PRODUCTION CANCELED POSTING].freeze
  belongs_to :client

  has_many :registers
  has_many :products, through: :registers
  accepts_nested_attributes_for :registers

  validates :status,
            inclusion: { in: STATUS, message: 'Invalid status' },
            presence: true
  validates :address, :city, :state, presence: true
  validates :code, presence: true, uniqueness: true
  validates :net_value, numericality: true, presence: true
  after_commit :update_sales_variant, on: :create
  validate :products_valid?

  def import_data(file)
    csv_file(file)
  end

  private

  def update_sales_variant
    registers.each do |register|
      sales = Register.where(variant_id: register.variant_id).sum(&:quantity)
      register.variant.update({ sales: sales })
    end
  end

  def products_valid?
    # errors.add(:regsiter, "can't be blank") if registers.empty? # should, but idk make on factory assoc
    return if registers.empty?

    registers.each do |register|
      next unless Variant.find_by_product_id_and_id(register.product_id, register.variant_id).nil?

      errors.add(
        :registers,
        "Variant #{register.variant_id} doesnt belongs that product #{register.product_id}"
      )
    end
  end

end
