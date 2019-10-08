class CreateConsultants < ActiveRecord::Migration
  def change
    create_table :consultants do |t|
      t.references :user, index: true
      t.string :realname
      t.string :tel
      t.string :email
      t.string :alipay
      t.string :dashang
      t.string :company
      t.string :position
      t.string :workyear
      t.integer :hourrate
      t.text :experience
      t.timestamps
    end
  end
end
