class CreateCategories < ActiveRecord::Migration[7.0]
  def up
    create_table :categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
