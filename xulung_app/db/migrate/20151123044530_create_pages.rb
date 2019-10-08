class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    t.string :title
      t.text :body
      t.string :author
      t.string :image

      t.timestamps
    end
    add_column :pages,:user_id,:integer
  	add_index :pages, :user_id
  end
end