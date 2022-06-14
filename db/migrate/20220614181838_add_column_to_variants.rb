class AddColumnToVariants < ActiveRecord::Migration[7.0]
  def up
    add_column :variants, :sales, :integer, default: 0
  end

  def down
    remove_column :variants, :sales
  end
end
