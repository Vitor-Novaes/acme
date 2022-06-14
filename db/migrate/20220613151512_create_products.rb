class CreateProducts < ActiveRecord::Migration[7.0]
  def up
    create_table :products do |t|
      t.decimal :base_value, precision: 8, scale: 2, null: false
      t.string :name, null: false
      t.references :category, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
