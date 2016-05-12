class AddCreditsOrder < ActiveRecord::Migration
  def up
    add_column :credits, :order, :integer

    execute <<~SQL
      UPDATE
        credits
      SET
        "order" = ordered_credits."order"
      FROM (
        SELECT
          credits.id AS id,
          row_number() over(PARTITION BY credits.post_id ORDER BY credit_roles."order") AS "order"
         FROM
           credits
          INNER JOIN
            credit_roles
          ON
            credits.credit_role_id = credit_roles.id
        ) AS ordered_credits
      WHERE
        credits."order" IS NULL
      AND
        credits.id = ordered_credits.id
    SQL

    change_column_null :credits, :order, false

    add_index :credits, [:post_id, :order], unique: true
  end

  def down
    remove_column :credits, :order
  end
end
