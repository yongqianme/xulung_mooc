class AddVideogroupToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :membergroup, :integer, :default => 0
  end
end
