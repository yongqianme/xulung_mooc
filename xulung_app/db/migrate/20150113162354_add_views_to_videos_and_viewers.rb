class AddViewsToVideosAndViewers < ActiveRecord::Migration
  def change
  	add_column :videos,:hit,:integer,:default=>0
  end
end
