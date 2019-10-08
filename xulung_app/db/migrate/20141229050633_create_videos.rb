class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :filename
      t.integer :filesize
      t.string :permalink
      t.text :description
      t.string :still

      t.timestamps
    end
end
  def self.down
    drop_table :videos
  end
end
