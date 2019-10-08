class AddApprovedToPostsVideos < ActiveRecord::Migration
  def change
  		add_column :posts, :approved, :boolean, :default => false
      add_index  :posts, :approved
      add_column :videos, :approved, :boolean, :default => false
      add_index  :videos, :approved
  end
end
