class AddRankingColumnToSite < ActiveRecord::Migration
  def change
    add_column :sites, :analytics_viewid, :string
    add_column :sites, :ranking_dimension, :string
    add_column :sites, :ranking_size, :integer, default: 5
  end
end
