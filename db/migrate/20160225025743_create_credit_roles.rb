class CreateCreditRoles < ActiveRecord::Migration
  def change
    create_table :credit_roles do |t|
      t.string :name, null: false
      t.integer :order, null: false
      t.references :site, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :credit_roles, [:site_id, :order], unique: true
  end
end
