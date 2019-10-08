class AddAvatarDashangToConsultant < ActiveRecord::Migration
  def change
    add_column :consultants, :avatar, :string
  end
end
