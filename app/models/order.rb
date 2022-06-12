# frozen_string_literal: true

# Order contains all over information about products and client relations
class Order < ApplicationRecord
  STATUS = %w[SENT WAITING PRODUCTION CANCELED POSTING].freeze

  belongs_to :client

  validates :status,
            inclusion: { in: STATUS, message: 'Invalid status' },
            presence: true
  validates :address, :city, :state, :code, presence: true
end
