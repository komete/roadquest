class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.actable as: :utilisateur
      t.string :nom
      t.string :prenom
      t.string :email
      t.integer :poste
      t.string :codeEmploye
      t.string :telephone
      t.string :username

      t.timestamps null: false
    end
  end
end
