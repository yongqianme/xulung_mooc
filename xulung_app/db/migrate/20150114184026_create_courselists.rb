class CreateCourselists < ActiveRecord::Migration
  def change
    create_table :courselists do |t|
      t.integer :user_id
      t.integer :video_id
      t.timestamps
    end
    add_column :videos,:courselist_id,:integer
  	add_index :videos, :courselist_id
  end
end
