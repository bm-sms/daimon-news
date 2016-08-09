class CreateCategorizations < ActiveRecord::Migration
  def up
    create_table :categorizations do |t|
      t.references :category, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false
      t.integer :order, null: false

      t.index %i(post_id category_id), unique: true
      t.index %i(post_id order), unique: true

      t.timestamps null: false
    end

    execute <<~SQL
      INSERT INTO
        categorizations (post_id, category_id, "order", created_at, updated_at)
        SELECT
          id, category_id, 1, now(), now()
        FROM
          posts;
    SQL
  end

  def down
    drop_table :categorizations
  end
end
