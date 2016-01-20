class RemoveNullConstraintFromSitesCssUrl < ActiveRecord::Migration
  def up
    change_column :sites, :css_url, :string, null: true
  end

  def down
    change_column :sites, :css_url, :string, null: false
  end
end
