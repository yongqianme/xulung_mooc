class ChangePublishedToTrue < ActiveRecord::Migration
  def self.up
  	change_column :videos, :published, :boolean,:default =>true
  end
  def self.down
  	change_column :videos, :published, :boolean,:default =>false
  end

end
