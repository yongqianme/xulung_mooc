class AddPostgroupToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :membergroup, :integer, :default => 0
  end
end
