class ChagneRelationImagesFromPostsToSites < ActiveRecord::Migration
  def up
    add_column :images, :site_id, :integer
    add_foreign_key :images, :sites

    execute <<~SQL
      UPDATE
        images
      SET
        site_id = posts.site_id
      FROM
        posts
      WHERE
        images.post_id = posts.id
    SQL

    change_column_null :images, :site_id, false

    remove_column :images, :post_id
  end

  def down
    add_column :images, :post_id, :integer
    add_foreign_key :images, :posts

    execute <<~SQL
      UPDATE
        images
      SET
        post_id = sites.id
      FROM
        sites, posts
      WHERE
        images.site_id = sites.id
        AND
        posts.site_id = sites.id
    SQL

    change_column_null :images, :post_id, false

    remove_column :images, :site_id
  end
end
