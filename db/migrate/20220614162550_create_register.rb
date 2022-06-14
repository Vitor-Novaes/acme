class CreateRegister < ActiveRecord::Migration[7.0]
  def up
    create_table :registers do |t|
      t.references :order, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false
      t.references :variant, foreign_key: true, null: false
      t.integer :quantity

      t.timestamps
    end
  end

  def down
    drop_table :registers
  end
end
