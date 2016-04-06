class AddVerifiyingAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verified_digest, :string
    add_column :users, :verified, :boolean, default: false
    add_column :users, :verified_at, :datetime
  end
end
