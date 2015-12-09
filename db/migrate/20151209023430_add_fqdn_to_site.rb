class AddFqdnToSite < ActiveRecord::Migration
  def change
    add_column :sites, :fqdn, :string, null: false, unique: true, default: "example.com"
  end
end
