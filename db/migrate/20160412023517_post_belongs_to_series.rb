class PostBelongsToSeries < ActiveRecord::Migration
  def change
    add_reference :posts, :series, foreign_key: true
  end
end
