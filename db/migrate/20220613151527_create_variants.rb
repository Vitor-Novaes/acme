class CreateVariants < ActiveRecord::Migration[7.0]
  def up
    create_table :variants do |t|
      t.string :code, null: false
      t.decimal :value, precision: 8, scale: 2, null: false
      t.string :image, null: false
      t.references :product, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :variants
  end
end
