class AddPublishedToPostsAndPages < ActiveRecord::Migration
  def self.up
		add_column :posts, :published, :boolean, :default => true
    add_column :pages, :published, :boolean, :default => true
	end

	def self.down
		remove_column :posts, :published
    remove_column :pages, :published
	end
end
