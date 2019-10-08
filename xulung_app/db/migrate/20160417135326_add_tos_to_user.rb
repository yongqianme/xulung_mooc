class AddTosToUser < ActiveRecord::Migration
  def change
    add_column :users, :terms_of_service, :boolean, :default => true
  end

end
