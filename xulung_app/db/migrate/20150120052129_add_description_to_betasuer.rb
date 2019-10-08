class AddDescriptionToBetasuer < ActiveRecord::Migration
  def change
  	add_column :betausers,:description,:text
  end
end
