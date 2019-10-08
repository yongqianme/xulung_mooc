class AddHitToPostsPages < ActiveRecord::Migration
  def change
    add_column :posts,:hit,:integer,:default=>3677
    add_column :pages,:hit,:integer,:default=>1677
  end
end
