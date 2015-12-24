class AddOrderToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :order, :integer

    execute 'UPDATE categories SET "order" = id WHERE "order" IS NULL'

    change_column_null :categories, :order, false
  end

  def down
    remove_column :categories, :order, :integer
  end
end
