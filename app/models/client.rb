# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :orders

  validates :email, uniqueness: true
  validates :name, presence: true

end
