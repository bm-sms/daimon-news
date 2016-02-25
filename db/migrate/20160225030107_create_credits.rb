class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.references :participant, index: true, foreign_key: true, null: false
      t.references :credit_role, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
