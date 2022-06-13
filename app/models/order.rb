class Order < ApplicationRecord
  STATUS = %w[SENT WAITING PRODUCTION CANCELED POSTING].freeze
  belongs_to :client

  validates :status,
            inclusion: { in: STATUS, message: 'Invalid status' },
            presence: true
  validates :address, :city, :state, presence: true
  validates :code, presence: true, uniqueness: true

  # TODO custom validation code on: :update
end
