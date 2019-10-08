class AddPostimgToPost < ActiveRecord::Migration
  def change
  	add_column :posts,:postimg,:stirng
  end
end
