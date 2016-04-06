class AddAdministrateurAttributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :administrateur, :boolean, default: false
  end
end
