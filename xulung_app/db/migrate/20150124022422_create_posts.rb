class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :author

      t.timestamps
    end
    add_column :posts,:user_id,:integer
  	add_index :posts, :user_id
  end
end
