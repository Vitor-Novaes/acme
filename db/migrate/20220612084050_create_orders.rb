# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def up
    create_table :orders do |t|
      t.string :code, index: { unique: true }
      t.datetime :payment_date
      t.string :status, null: false, default: 'WAITING'
      t.string :state, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.references :client, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :orders
  end
end
