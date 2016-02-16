class AddColumnPostPublicId < ActiveRecord::Migration
  def up
    add_column :posts, :public_id, :integer

    execute 'UPDATE posts SET public_id = id'

    change_column_null :posts, :public_id, false

    add_index :posts, %i(site_id public_id), unique: true
  end

  def down
    remove_column :posts, :public_id
  end
end
