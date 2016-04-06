class CreateProduits < ActiveRecord::Migration
  def change
    create_table :produits do |t|
      t.string :nom
      t.string :type_produit
      t.date :expiration
      t.string :reference
      t.references :marquage, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :produits, [:marquage_id, :created_at]
  end
end
