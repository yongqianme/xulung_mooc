class AddVisitoridsToVideos < ActiveRecord::Migration
  def change

  	add_column :videos,:visitor_ids,:text
  	
  end
end
