class RemoveRoleFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :role, null: false, default: "user"
  end
end
