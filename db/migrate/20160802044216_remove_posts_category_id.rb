class RemovePostsCategoryId < ActiveRecord::Migration
  def up
    remove_column :posts, :category_id
  end

  def down
    add_column :posts, :category_id, :integer, null: true

    execute <<~SQL
      UPDATE
        posts
      SET
        category_id = (
                       SELECT
                         category_id
                       FROM
                         categorizations
                       WHERE
                         post_id = posts.id
                       ORDER BY
                         "order"
                       LIMIT
                         1
                      );
    SQL
  end
end
