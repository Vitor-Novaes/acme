class Client < ApplicationRecord
  has_many :orders

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
  validates :name, presence: true
end
