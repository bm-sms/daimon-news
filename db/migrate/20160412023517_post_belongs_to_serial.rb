class PostBelongsToSerial < ActiveRecord::Migration
  def change
    add_reference :posts, :serial, foreign_key: true, index: true
  end
end
