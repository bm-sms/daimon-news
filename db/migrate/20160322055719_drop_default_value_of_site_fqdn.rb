class DropDefaultValueOfSiteFqdn < ActiveRecord::Migration
  def up
    change_column_default :sites, :fqdn, nil
  end

  def down
    change_column_default :sites, :fqdn, "example.com"
  end
end
