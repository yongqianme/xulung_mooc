class AddPostToTaggings < ActiveRecord::Migration
  def change
  	 add_reference :taggings, :post, index: true
  end
end
