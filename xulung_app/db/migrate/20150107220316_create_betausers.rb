class CreateBetausers < ActiveRecord::Migration
  def change
    create_table :betausers do |t|
      t.string :email

      t.timestamps
    end
    add_index :betausers, :email,unique: true
  end
end
