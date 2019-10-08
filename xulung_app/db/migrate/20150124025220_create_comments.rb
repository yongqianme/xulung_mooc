class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, index: true
      t.text :body
      t.string :author
      t.string :email


      t.timestamps
    end
    add_column :comments,:user_id,:integer
  	add_index :comments, :user_id
  end
end
