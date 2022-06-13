# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.0]
  def up
    create_table :clients do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: false

      t.timestamps
    end
  end

  def down
    drop_table :clients
  end
end
