class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :subject
      t.string :out_trade_no
      t.float :total_fee
      t.integer :membership_id
      t.string :trade_status

      t.timestamps
    end
    add_column :orders,:user_id,:integer
  	add_index :orders, :user_id
  end
end
